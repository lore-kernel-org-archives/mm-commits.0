From: akpm@linux-foundation.org
Subject: + hpfall-accept-disk-device-to-unload-as-argument.patch added to -mm tree
Date: Tue, 28 Jul 2009 14:36:51 -0700
Message-ID: <200907282136.n6SLap2O003080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZG1VhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 17:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, ct@pipapo.org, pavel@ucw.cz


The patch titled
     hpfall: accept disk device to unload as argument
has been added to the -mm tree.  Its filename is
     hpfall-accept-disk-device-to-unload-as-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpfall: accept disk device to unload as argument
From: Frans Pop <elendil@planet.nl>

Allows users who use an IDE driver for their disk to use hpfall without
having to modify the source. By default /dev/sda is used.
Suggested by Christian Thaeter in http://lkml.org/lkml/2009/3/25/505.

While we're add it, improve error message if opening /dev/freefall fails.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/hpfall.c |   45 ++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff -puN Documentation/hwmon/hpfall.c~hpfall-accept-disk-device-to-unload-as-argument Documentation/hwmon/hpfall.c
--- a/Documentation/hwmon/hpfall.c~hpfall-accept-disk-device-to-unload-as-argument
+++ a/Documentation/hwmon/hpfall.c
@@ -19,6 +19,32 @@
 #include <sys/mman.h>
 #include <sched.h>
 
+char unload_heads_path[64];
+
+int set_unload_heads_path(char *device)
+{
+	char devname[64];
+
+	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
+		return -EINVAL;
+	strncpy(devname, device + 5, sizeof(devname));
+
+	snprintf(unload_heads_path, sizeof(unload_heads_path),
+				"/sys/block/%s/device/unload_heads", devname);
+	return 0;
+}
+int valid_disk(void)
+{
+	int fd = open(unload_heads_path, O_RDONLY);
+	if (fd < 0) {
+		perror(unload_heads_path);
+		return 0;
+	}
+
+	close(fd);
+	return 1;
+}
+
 void write_int(char *path, int i)
 {
 	char buf[1024];
@@ -42,7 +68,7 @@ void set_led(int on)
 
 void protect(int seconds)
 {
-	write_int("/sys/block/sda/device/unload_heads", seconds*1000);
+	write_int(unload_heads_path, seconds*1000);
 }
 
 int on_ac(void)
@@ -61,14 +87,27 @@ void ignore_me(void)
 	set_led(0);
 }
 
-int main(int argc, char *argv[])
+int main(int argc, char **argv)
 {
 	int fd, ret;
 	struct sched_param param;
 
+	if (argc == 1)
+		ret = set_unload_heads_path("/dev/sda");
+	else if (argc == 2)
+		ret = set_unload_heads_path(argv[1]);
+	else
+		ret = -EINVAL;
+
+	if (ret || !valid_disk()) {
+		fprintf(stderr, "usage: %s <device> (default: /dev/sda)\n",
+				argv[0]);
+		exit(1);
+	}
+
 	fd = open("/dev/freefall", O_RDONLY);
 	if (fd < 0) {
-		perror("open");
+		perror("/dev/freefall");
 		return EXIT_FAILURE;
 	}
 
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
mm-improve-help-text-for-mm-debug-config-options.patch
hpfall-reduce-risk-that-hpfall-can-do-harm.patch
hpfall-accept-disk-device-to-unload-as-argument.patch

