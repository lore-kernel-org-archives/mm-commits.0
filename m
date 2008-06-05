From: akpm@linux-foundation.org
Subject: + rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch added to -mm tree
Date: Wed, 04 Jun 2008 18:32:29 -0700
Message-ID: <200806050132.m551WTx4019184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYFEBdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 21:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, alan@lxorguk.ukuu.org.uk


The patch titled
     drivers/char/rtc.c: fix build failure
has been added to the -mm tree.  Its filename is
     rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc.c: fix build failure
From: Li Zefan <lizf@cn.fujitsu.com>

This patch caused build failure:
	rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

drivers/char/rtc.c:721: error: conflicting types for `rtc_ioctl'
drivers/char/rtc.c:146: error: previous declaration of `rtc_ioctl' was here

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix
+++ a/drivers/char/rtc.c
@@ -143,7 +143,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_d
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
git-leds.patch
scsi-libiscsic-return-errno-rather-than-errno.patch
call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

