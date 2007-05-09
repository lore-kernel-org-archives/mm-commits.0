From: akpm@linux-foundation.org
Subject: - rtc-cmos-wakeup-interface.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:29 -0700
Message-ID: <200705090254.l492sTWe009808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032367AbXEICzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos wakeup interface
has been removed from the -mm tree.  Its filename was
     rtc-cmos-wakeup-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-cmos wakeup interface
From: David Brownell <david-b@pacbell.net>

I finally got around to testing the updated wakeup event hooks for rtc-cmos,
and they follow in two patches:

 - Interface update ... when a simple enable_irq_wake() doesn't suffice,
   the platform data can hold suspend/resume callback hooks.

 - ACPI implementation ... provides callback hooks to do ACPI magic, and
   eliminate the legacy /proc/acpi/alarm file.

The interface update could go into 2.6.21, but that's not essential; they
will be NOPs on most PCs, without the ACPI stuff.

I suspect the ACPI folk may have opinions about how to merge that second
patch, and how to obsolete that legacy procfs file.  I'd like to see that
merge into 2.6.22 if possible...


As for how to kick it in ... two ways:

 - The appended "rtcwake" program; updated since the last time it was
   posted, it deals much better with timezones and DST.

 - Write the /sys/class/rtc/.../wakealarm file, then go to sleep.

For some reason RTC wake from "swsusp" stopped working on a system where
it previously worked; the alarm setting appears to get clobbered.  But
on the bright side, RTC wake from "standby" worked on a system that had
never been able to resume from that state before ... IDEACPI is my guess
as to why it finally started to work.  It's the old "two steps forward,
one step back" dance, I guess.

- Dave

/* gcc -Wall -Os -o rtcwake rtcwake.c */

#include <stdio.h>
#include <getopt.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>

#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>

#include <linux/rtc.h>

/* constants from legacy PC/AT hardware */
#define	RTC_PF	0x40
#define	RTC_AF	0x20
#define	RTC_UF	0x10


/*
 * rtcwake -- enter a system sleep state until specified wakeup time.
 *
 * This uses cross-platform Linux interfaces to enter a system sleep state,
 * and leave it no later than a specified time.  It uses any RTC framework
 * driver that supports standard driver model wakeup flags.
 *
 * This is normally used like the old "apmsleep" utility, to wake from a
 * suspend state like ACPI S1 (standby) or S3 (suspend-to-RAM).  Most
 * platforms can implement those without analogues of BIOS, APM, or ACPI.
 *
 * On some systems, this can also be used like "nvram-wakeup", waking
 * from states like ACPI S4 (suspend to disk).  Not all systems have
 * persistent media that are appropriate for such suspend modes.
 *
 * The best way to set the system's RTC is so that it holds the current
 * time in UTC.  Use the "-l" flag to tell this program that the system
 * RTC uses a local timezone instead (maybe you dual-boot MS-Windows).
 */

static char		*progname;

#ifdef	DEBUG
#define	VERSION	"1.0 dev (" __DATE__ " " __TIME__ ")"
#else
#define	VERSION	"0.9"
#endif

static unsigned		verbose;
static int		rtc_is_utc = -1;

static int may_wakeup(const char *devname)
{
	char	buf[128], *s;
	FILE	*f;

	snprintf(buf, sizeof buf, "/sys/class/rtc/%s/device/power/wakeup",
			devname);
	f = fopen(buf, "r");
	if (!f) {
		perror(buf);
		return 0;
	}
	fgets(buf, sizeof buf, f);
	fclose(f);

	s = strchr(buf, '\n');
	if (!s)
		return 0;
	*s = 0;

	/* wakeup events could be disabled or not supported */
	return strcmp(buf, "enabled") == 0;
}

/* all times should be in UTC */
static time_t	sys_time;
static time_t	rtc_time;

static int get_basetimes(int fd)
{
	struct tm	tm;
	struct rtc_time	rtc;

	/* this process works in RTC time, except when working
	 * with the system clock (which always uses UTC).
	 */
	if (rtc_is_utc)
		setenv("TZ", "UTC", 1);
	tzset();

	/* read rtc and system clocks "at the same time", or as
	 * precisely (+/- a second) as we can read them.
	 */
	if (ioctl(fd, RTC_RD_TIME, &rtc) < 0) {
		perror("read rtc time");
		return 0;
	}
	sys_time = time(0);
	if (sys_time == (time_t)-1) {
		perror("read system time");
		return 0;
	}

	/* convert rtc_time to normal arithmetic-friendly form,
	 * updating tm.tm_wday as used by asctime().
	 */
	memset(&tm, 0, sizeof tm);
	tm.tm_sec = rtc.tm_sec;
	tm.tm_min = rtc.tm_min;
	tm.tm_hour = rtc.tm_hour;
	tm.tm_mday = rtc.tm_mday;
	tm.tm_mon = rtc.tm_mon;
	tm.tm_year = rtc.tm_year;
	tm.tm_isdst = rtc.tm_isdst;	/* stays unspecified? */
	rtc_time = mktime(&tm);

	if (rtc_time == (time_t)-1) {
		perror("convert rtc time");
		return 0;
	}

	if (verbose) {
		if (!rtc_is_utc) {
			printf("\ttzone   = %ld\n", timezone);
			printf("\ttzname  = %s\n", tzname[daylight]);
			gmtime_r(&rtc_time, &tm);
		}
		printf("\tsystime = %ld, (UTC) %s",
				(long) sys_time, asctime(gmtime(&sys_time)));
		printf("\trtctime = %ld, (UTC) %s",
				(long) rtc_time, asctime(&tm));
	}

	return 1;
}

static int setup_alarm(int fd, time_t *wakeup)
{
	struct tm		*tm;
	struct rtc_wkalrm	wake;

	tm = gmtime(wakeup);

	wake.time.tm_sec = tm->tm_sec;
	wake.time.tm_min = tm->tm_min;
	wake.time.tm_hour = tm->tm_hour;
	wake.time.tm_mday = tm->tm_mday;
	wake.time.tm_mon = tm->tm_mon;
	wake.time.tm_year = tm->tm_year;
	wake.time.tm_wday = tm->tm_wday;
	wake.time.tm_yday = tm->tm_yday;
	wake.time.tm_isdst = tm->tm_isdst;

	/* many rtc alarms only support up to 24 hours from 'now' ... */
	if ((rtc_time + (24 * 60 * 60)) > *wakeup) {
		if (ioctl(fd, RTC_ALM_SET, &wake.time) < 0) {
			perror("set rtc alarm");
			return 0;
		}
		if (ioctl(fd, RTC_AIE_ON, 0) < 0) {
			perror("enable rtc alarm");
			return 0;
		}

	/* ... so use the "more than 24 hours" request only if we must */
	} else {
		/* avoid an extra AIE_ON call */
		wake.enabled = 1;

		if (ioctl(fd, RTC_WKALM_SET, &wake) < 0) {
			perror("set rtc wake alarm");
			return 0;
		}
	}

	return 1;
}

static void suspend_system(const char *suspend)
{
	FILE	*f = fopen("/sys/power/state", "w");

	if (!f) {
		perror("/sys/power/state");
		return;
	}

	fprintf(f, "%s\n", suspend);
	fflush(f);

	/* this executes after wake from suspend */
	fclose(f);
}

int main(int argc, char **argv)
{
	static char		*devname = "rtc0";
	static unsigned		seconds = 0;
	static char		*suspend = "standby";

	int		t;
	int		fd;
	time_t		alarm = 0;

	progname = strrchr(argv[0], '/');
	if (progname)
		progname++;
	else
		progname = argv[0];
	if (chdir("/dev/") < 0) {
		perror("chdir /dev");
		return 1;
	}

	while ((t = getopt(argc, argv, "d:lm:s:t:uVv")) != EOF) {
		switch (t) {

		case 'd':
			devname = optarg;
			break;

		case 'l':
			rtc_is_utc = 0;
			break;

		/* what system power mode to use?  for now handle only
		 * standardized mode names; eventually when systems define
		 * their own state names, parse /sys/power/state.
		 *
		 * "on" is used just to test the RTC alarm mechanism,
		 * bypassing all the wakeup-from-sleep infrastructure.
		 */
		case 'm':
			if (strcmp(optarg, "standby") == 0
					|| strcmp(optarg, "mem") == 0
					|| strcmp(optarg, "disk") == 0
					|| strcmp(optarg, "on") == 0
					) {
				suspend = optarg;
				break;
			}
			printf("%s: unrecognized suspend state '%s'\n",
					progname, optarg);
			goto usage;

		/* alarm time, seconds-to-sleep (relative) */
		case 's':
			t = atoi(optarg);
			if (t < 0) {
				printf("%s: illegal interval %s seconds\n",
						progname, optarg);
				goto usage;
			}
			seconds = t;
			break;

		/* alarm time, time_t (absolute, seconds since 1/1 1970 UTC) */
		case 't':
			t = atoi(optarg);
			if (t < 0) {
				printf("%s: illegal time_t value %s\n",
						progname, optarg);
				goto usage;
			}
			alarm = t;
			break;

		case 'u':
			rtc_is_utc = 1;
			break;

		case 'v':
			verbose++;
			break;

		case 'V':
			printf("%s: version %s\n", progname, VERSION);
			break;

		default:
usage:
			printf("usage: %s [options]"
				"\n\t"
				"-d rtc0|rtc1|...\t(select rtc)"
				"\n\t"
				"-l\t\t\t(RTC uses local timezone)"
				"\n\t"
				"-m standby|mem|...\t(sleep mode)"
				"\n\t"
				"-s seconds\t\t(seconds to sleep)"
				"\n\t"
				"-t time_t\t\t(time to wake)"
				"\n\t"
				"-u\t\t\t(RTC uses UTC)"
				"\n\t"
				"-v\t\t\t(verbose messages)"
				"\n\t"
				"-V\t\t\t(show version)"
				"\n",
				progname);
			return 1;
		}
	}

	if (!alarm && !seconds) {
		printf("%s: must provide wake time\n", progname);
		goto usage;
	}

	/* REVISIT:  if /etc/adjtime exists, read it to see what
	 * the util-linux version of hwclock assumes.
	 */
	if (rtc_is_utc == -1) {
		printf("%s: assuming RTC uses UTC ...\n", progname);
		rtc_is_utc = 1;
	}

	/* this RTC must exist and (if we'll sleep) be wakeup-enabled */
	fd = open(devname, O_RDONLY);
	if (fd < 0) {
		perror(devname);
		return 1;
	}
	if (strcmp(suspend, "on") != 0 && !may_wakeup(devname)) {
		printf("%s: %s not enabled for wakeup events\n",
				progname, devname);
		return 1;
	}

	/* relative or absolute alarm time, normalized to time_t */
	if (!get_basetimes(fd))
		return 1;
	if (verbose)
		printf("alarm %ld, sys_time %ld, rtc_time %ld, seconds %u\n",
				alarm, sys_time, rtc_time, seconds);
	if (alarm) {
		if (alarm < sys_time) {
			printf("%s: time doesn't go backward to %s",
					progname, ctime(&alarm));
			return 1;
		}
		alarm += sys_time - rtc_time;
	} else
		alarm = rtc_time + seconds + 1;
	if (setup_alarm(fd, &alarm) < 0)
		return 1;

	sync();
	printf("%s: wakeup from \"%s\" using %s at %s",
			progname, suspend, devname,
			ctime(&alarm));
	fflush(stdout);
	usleep(10 * 1000);

	if (strcmp(suspend, "on") != 0)
		suspend_system(suspend);
	else {
		unsigned long data;

		do {
			t = read(fd, &data, sizeof data);
			if (t < 0) {
				perror("rtc read");
				break;
			}
			if (verbose)
				printf("... %s: %03lx\n", devname, data);
		} while (!(data & RTC_AF));
	}

	if (ioctl(fd, RTC_AIE_OFF, 0) < 0)
		perror("disable rtc alarm interrupt");

	close(fd);
	return 0;
}



This patch:

Make rtc-cmos do the relevant magic so this RTC can wake the system from a
sleep state.  That magic comes in two basic flavors:

 - Straightforward:  enable_irq_wake(), the way it'd work on most SOC chips;
   or generally with system sleep states which don't disable core IRQ logic.

 - Roundabout, using non-IRQ platform hooks.  This is needed with ACPI and
   one almost-clone chip which uses a special wakeup-only alarm.  (That's
   the RTC used on Footbridge boards, FWIW, which don't do PM in Linux.)

A separate patch implements those hooks for ACPI platforms, so that rtc_cmos
can issue system wakeup events (and its sysfs "wakealarm" attribute works on
at least some systems).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c      |   37 ++++++++++++++++++++++++----------
 include/linux/mc146818rtc.h |    7 ++++++
 2 files changed, 34 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-wakeup-interface drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-wakeup-interface
+++ a/drivers/rtc/rtc-cmos.c
@@ -46,6 +46,10 @@ struct cmos_rtc {
 	int			irq;
 	struct resource		*iomem;
 
+	void			(*wake_on)(struct device *);
+	void			(*wake_off)(struct device *);
+
+	u8			enabled_wake;
 	u8			suspend_ctrl;
 
 	/* newer hardware extends the original register set */
@@ -405,13 +409,20 @@ cmos_do_probe(struct device *dev, struct
 	cmos_rtc.irq = rtc_irq;
 	cmos_rtc.iomem = ports;
 
-	/* For ACPI systems the info comes from the FADT.  On others,
-	 * board specific setup provides it as appropriate.
+	/* For ACPI systems extension info comes from the FADT.  On others,
+	 * board specific setup provides it as appropriate.  Systems where
+	 * the alarm IRQ isn't automatically a wakeup IRQ (like ACPI, and
+	 * some almost-clones) can provide hooks to make that behave.
 	 */
 	if (info) {
 		cmos_rtc.day_alrm = info->rtc_day_alarm;
 		cmos_rtc.mon_alrm = info->rtc_mon_alarm;
 		cmos_rtc.century = info->rtc_century;
+
+		if (info->wake_on && info->wake_off) {
+			cmos_rtc.wake_on = info->wake_on;
+			cmos_rtc.wake_off = info->wake_off;
+		}
 	}
 
 	cmos_rtc.rtc = rtc_device_register(driver_name, dev,
@@ -559,9 +570,13 @@ static int cmos_suspend(struct device *d
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	/* ACPI HOOK:  enable ACPI_EVENT_RTC when (tmp & RTC_AIE)
-	 * ... it'd be best if we could do that under rtc_lock.
-	 */
+	if (tmp & RTC_AIE) {
+		cmos->enabled_wake = 1;
+		if (cmos->wake_on)
+			cmos->wake_on(dev);
+		else
+			enable_irq_wake(cmos->irq);
+	}
 
 	pr_debug("%s: suspend%s, ctrl %02x\n",
 			cmos_rtc.rtc->dev.bus_id,
@@ -576,14 +591,16 @@ static int cmos_resume(struct device *de
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp = cmos->suspend_ctrl;
 
-	/* REVISIT:  a mechanism to resync the system clock (jiffies)
-	 * on resume should be portable between platforms ...
-	 */
-
 	/* re-enable any irqs previously active */
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 
-		/* ACPI HOOK:  disable ACPI_EVENT_RTC when (tmp & RTC_AIE) */
+		if (cmos->enabled_wake) {
+			if (cmos->wake_off)
+				cmos->wake_off(dev);
+			else
+				disable_irq_wake(cmos->irq);
+			cmos->enabled_wake = 0;
+		}
 
 		spin_lock_irq(&rtc_lock);
 		CMOS_WRITE(tmp, RTC_CONTROL);
diff -puN include/linux/mc146818rtc.h~rtc-cmos-wakeup-interface include/linux/mc146818rtc.h
--- a/include/linux/mc146818rtc.h~rtc-cmos-wakeup-interface
+++ a/include/linux/mc146818rtc.h
@@ -22,8 +22,15 @@ extern spinlock_t rtc_lock;		/* serializ
 /* Some RTCs extend the mc146818 register set to support alarms of more
  * than 24 hours in the future; or dates that include a century code.
  * This platform_data structure can pass this information to the driver.
+ *
+ * Also, some platforms need suspend()/resume() hooks to kick in special
+ * handling of wake alarms, e.g. activating ACPI BIOS hooks or setting up
+ * a separate wakeup alarm used by some almost-clone chips.
  */
 struct cmos_rtc_board_info {
+	void	(*wake_on)(struct device *dev);
+	void	(*wake_off)(struct device *dev);
+
 	u8	rtc_day_alarm;		/* zero, or register index */
 	u8	rtc_mon_alarm;		/* zero, or register index */
 	u8	rtc_century;		/* zero, or register index */
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
