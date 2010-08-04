From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 04 Aug 2010 12:07:09 -0700
Message-ID: <201008041906.o74J6BlM004313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933602Ab0HDTGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 15:06:14 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o74J6Cth002176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 4 Aug 2010 12:06:13 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/IR/ir-sysfs.c              |  107 ---------------------
 drivers/media/dvb/dvb-usb/dib0700_core.c |    5 
 drivers/media/video/omap/omap_vout.c     |    7 -
 drivers/staging/Kconfig                  |    3 
 drivers/staging/tm6000/tm6000-core.c     |    9 -
 security/apparmor/domain.c               |    4 
 security/apparmor/lsm.c                  |   38 -------
 7 files changed, 173 deletions(-)

diff -puN drivers/media/IR/ir-sysfs.c~linux-next-git-rejects drivers/media/IR/ir-sysfs.c
--- a/drivers/media/IR/ir-sysfs.c~linux-next-git-rejects
+++ a/drivers/media/IR/ir-sysfs.c
@@ -65,10 +65,7 @@ static ssize_t show_protocols(struct dev
 	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
 	u64 allowed, enabled;
 	char *tmp = buf;
-<<<<<<< HEAD
 	int i;
-=======
->>>>>>> FETCH_HEAD
 
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
@@ -77,19 +74,6 @@ static ssize_t show_protocols(struct dev
 		enabled = ir_dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
 	}
-<<<<<<< HEAD
-
-	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
-		   (long long)allowed,
-		   (long long)enabled);
-
-	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-		if (allowed & enabled & proto_names[i].type)
-			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
-		else if (allowed & proto_names[i].type)
-			tmp += sprintf(tmp, "%s ", proto_names[i].name);
-	}
-=======
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
@@ -129,7 +113,6 @@ static ssize_t show_protocols(struct dev
 		tmp += sprintf(tmp, "[lirc] ");
 	else if (allowed & IR_TYPE_LIRC)
 		tmp += sprintf(tmp, "lirc ");
->>>>>>> FETCH_HEAD
 
 	if (tmp != buf)
 		tmp--;
@@ -149,10 +132,7 @@ static ssize_t show_protocols(struct dev
  * Writing "+proto" will add a protocol to the list of enabled protocols.
  * Writing "-proto" will remove a protocol from the list of enabled protocols.
  * Writing "proto" will enable only "proto".
-<<<<<<< HEAD
  * Writing "none" will disable all protocols.
-=======
->>>>>>> FETCH_HEAD
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  */
@@ -166,85 +146,6 @@ static ssize_t store_protocols(struct de
 	const char *tmp;
 	u64 type;
 	u64 mask;
-<<<<<<< HEAD
-	int rc, i, count = 0;
-	unsigned long flags;
-
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
-	else
-		type = ir_dev->raw->enabled_protocols;
-
-	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
-		if (!*tmp)
-			break;
-
-		if (*tmp == '+') {
-			enable = true;
-			disable = false;
-			tmp++;
-		} else if (*tmp == '-') {
-			enable = false;
-			disable = true;
-			tmp++;
-		} else {
-			enable = false;
-			disable = false;
-		}
-
-		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
-			tmp += sizeof(PROTO_NONE);
-			mask = 0;
-			count++;
-		} else {
-			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
-					tmp += strlen(proto_names[i].name);
-					mask = proto_names[i].type;
-					break;
-				}
-			}
-			if (i == ARRAY_SIZE(proto_names)) {
-				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-				return -EINVAL;
-			}
-			count++;
-		}
-
-		if (enable)
-			type |= mask;
-		else if (disable)
-			type &= ~mask;
-		else
-			type = mask;
-	}
-
-	if (!count) {
-		IR_dprintk(1, "Protocol not specified\n");
-		return -EINVAL;
-	}
-
-	if (ir_dev->props && ir_dev->props->change_protocol) {
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    type);
-		if (rc < 0) {
-			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-				   (long long)type);
-			return -EINVAL;
-		}
-	}
-
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
-		ir_dev->rc_tab.ir_type = type;
-		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-	} else {
-		ir_dev->raw->enabled_protocols = type;
-	}
-
-	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
-		   (long long)type);
-=======
 	int rc;
 	unsigned long flags;
 
@@ -306,7 +207,6 @@ static ssize_t store_protocols(struct de
 		type &= ~mask;
 	else
 		type = mask;
->>>>>>> FETCH_HEAD
 
 	if (ir_dev->props && ir_dev->props->change_protocol) {
 		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
@@ -318,8 +218,6 @@ static ssize_t store_protocols(struct de
 		}
 	}
 
-<<<<<<< HEAD
-=======
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
 		ir_dev->rc_tab.ir_type = type;
@@ -335,7 +233,6 @@ static ssize_t store_protocols(struct de
 	return len;
 }
 
->>>>>>> FETCH_HEAD
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
 	do {								\
 		int err = add_uevent_var(env, fmt, val);		\
@@ -398,10 +295,6 @@ int ir_register_class(struct input_dev *
 		return devno;
 
 	ir_dev->dev.type = &rc_dev_type;
-<<<<<<< HEAD
-
-=======
->>>>>>> FETCH_HEAD
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
 	dev_set_name(&ir_dev->dev, "rc%d", devno);
diff -puN drivers/media/dvb/dvb-usb/dib0700_core.c~linux-next-git-rejects drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c~linux-next-git-rejects
+++ a/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -613,10 +613,6 @@ resubmit:
 int dib0700_rc_setup(struct dvb_usb_device *d)
 {
 	struct dib0700_state *st = d->priv;
-<<<<<<< HEAD
-	struct urb *purb;
-	int ret;
-=======
 	u8 rc_setup[3] = { REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0 };
 	struct urb *purb;
 	int ret;
@@ -631,7 +627,6 @@ int dib0700_rc_setup(struct dvb_usb_devi
 		err("ir protocol setup failed");
 		return i;
 	}
->>>>>>> FETCH_HEAD
 
 	/* Poll-based. Don't initialize bulk mode */
 	if (st->fw_version < 0x10200)
diff -puN drivers/media/video/omap/omap_vout.c~linux-next-git-rejects drivers/media/video/omap/omap_vout.c
--- a/drivers/media/video/omap/omap_vout.c~linux-next-git-rejects
+++ a/drivers/media/video/omap/omap_vout.c
@@ -2545,17 +2545,10 @@ static int __init omap_vout_probe(struct
 			/* set the update mode */
 			if (def_display->caps &
 					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
-<<<<<<< HEAD
-				if (dssdrv->enable_te)
-					dssdrv->enable_te(def_display, 0);
-				if (dssdrv->set_update_mode)
-					dssdrv->set_update_mode(def_display,
-=======
 				if (def_display->enable_te)
 					def_display->enable_te(def_display, 0);
 				if (def_display->set_update_mode)
 					def_display->set_update_mode(def_display,
->>>>>>> FETCH_HEAD
 							OMAP_DSS_UPDATE_MANUAL);
 			} else {
 				if (def_display->set_update_mode)
diff -puN drivers/staging/Kconfig~linux-next-git-rejects drivers/staging/Kconfig
--- a/drivers/staging/Kconfig~linux-next-git-rejects
+++ a/drivers/staging/Kconfig
@@ -147,8 +147,6 @@ source "drivers/staging/msm/Kconfig"
 
 source "drivers/staging/lirc/Kconfig"
 
-<<<<<<< HEAD
-=======
 source "drivers/staging/easycap/Kconfig"
 
 source "drivers/staging/solo6x10/Kconfig"
@@ -157,6 +155,5 @@ source "drivers/staging/tidspbridge/Kcon
 
 source "drivers/staging/quickstart/Kconfig"
 
->>>>>>> FETCH_HEAD
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff -puN drivers/staging/tm6000/tm6000-core.c~linux-next-git-rejects drivers/staging/tm6000/tm6000-core.c
--- a/drivers/staging/tm6000/tm6000-core.c~linux-next-git-rejects
+++ a/drivers/staging/tm6000/tm6000-core.c
@@ -335,15 +335,6 @@ int tm6000_init_analog_mode(struct tm600
 	msleep(100);
 	tm6000_set_standard(dev, &dev->norm);
 	tm6000_set_audio_bitrate(dev, 48000);
-<<<<<<< HEAD
-=======
-
-	/* switch dvb led off */
-	if (dev->gpio.dvb_led) {
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-			dev->gpio.dvb_led, 0x01);
-	}
->>>>>>> FETCH_HEAD
 
 	/* switch dvb led off */
 	if (dev->gpio.dvb_led) {
diff -puN security/apparmor/domain.c~linux-next-git-rejects security/apparmor/domain.c
--- a/security/apparmor/domain.c~linux-next-git-rejects
+++ a/security/apparmor/domain.c
@@ -62,11 +62,7 @@ static int may_change_ptraced_domain(str
 				     struct aa_profile *to_profile)
 {
 	struct task_struct *tracer;
-<<<<<<< HEAD
-	const struct cred *cred = NULL;
-=======
 	struct cred *cred = NULL;
->>>>>>> FETCH_HEAD
 	struct aa_profile *tracerp = NULL;
 	int error = 0;
 
diff -puN security/apparmor/lsm.c~linux-next-git-rejects security/apparmor/lsm.c
--- a/security/apparmor/lsm.c~linux-next-git-rejects
+++ a/security/apparmor/lsm.c
@@ -667,19 +667,6 @@ static struct security_operations apparm
  * AppArmor sysfs module parameters
  */
 
-<<<<<<< HEAD
-static int param_set_aabool(const char *val, struct kernel_param *kp);
-static int param_get_aabool(char *buffer, struct kernel_param *kp);
-#define param_check_aabool(name, p) __param_check(name, p, int)
-
-static int param_set_aauint(const char *val, struct kernel_param *kp);
-static int param_get_aauint(char *buffer, struct kernel_param *kp);
-#define param_check_aauint(name, p) __param_check(name, p, int)
-
-static int param_set_aalockpolicy(const char *val, struct kernel_param *kp);
-static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp);
-#define param_check_aalockpolicy(name, p) __param_check(name, p, int)
-=======
 static int param_set_aabool(const char *val, const struct kernel_param *kp);
 static int param_get_aabool(char *buffer, const struct kernel_param *kp);
 #define param_check_aabool(name, p) __param_check(name, p, int)
@@ -703,7 +690,6 @@ static struct kernel_param_ops param_ops
 	.set = param_set_aalockpolicy,
 	.get = param_get_aalockpolicy
 };
->>>>>>> FETCH_HEAD
 
 static int param_set_audit(const char *val, struct kernel_param *kp);
 static int param_get_audit(char *buffer, struct kernel_param *kp);
@@ -777,11 +763,7 @@ static int __init apparmor_enabled_setup
 __setup("apparmor=", apparmor_enabled_setup);
 
 /* set global flag turning off the ability to load policy */
-<<<<<<< HEAD
-static int param_set_aalockpolicy(const char *val, struct kernel_param *kp)
-=======
 static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -790,55 +772,35 @@ static int param_set_aalockpolicy(const 
 	return param_set_bool(val, kp);
 }
 
-<<<<<<< HEAD
-static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp)
-=======
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
-<<<<<<< HEAD
-static int param_set_aabool(const char *val, struct kernel_param *kp)
-=======
 static int param_set_aabool(const char *val, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_set_bool(val, kp);
 }
 
-<<<<<<< HEAD
-static int param_get_aabool(char *buffer, struct kernel_param *kp)
-=======
 static int param_get_aabool(char *buffer, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
-<<<<<<< HEAD
-static int param_set_aauint(const char *val, struct kernel_param *kp)
-=======
 static int param_set_aauint(const char *val, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_set_uint(val, kp);
 }
 
-<<<<<<< HEAD
-static int param_get_aauint(char *buffer, struct kernel_param *kp)
-=======
 static int param_get_aauint(char *buffer, const struct kernel_param *kp)
->>>>>>> FETCH_HEAD
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
revert-old-timer-added-usleep_range-timer.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
checkpatch-prefer-usleep_range-over-udelay-fix.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

