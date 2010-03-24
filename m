From: akpm@linux-foundation.org
Subject: + fscache-add-missing-unlock.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:31:21 -0700
Message-ID: <201003242131.o2OLVLhK028222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488Ab0CXVbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dhowells@redhat.com


The patch titled
     fscache: add missing unlock
has been added to the -mm tree.  Its filename is
     fscache-add-missing-unlock.patch

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
Subject: fscache: add missing unlock
From: Dan Carpenter <error27@gmail.com>

Sparse complained about this missing spin_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/page.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fscache/page.c~fscache-add-missing-unlock fs/fscache/page.c
--- a/fs/fscache/page.c~fscache-add-missing-unlock
+++ a/fs/fscache/page.c
@@ -881,6 +881,7 @@ submit_failed:
 	goto nobufs;
 
 nobufs_unlock_obj:
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 nobufs:
 	spin_unlock(&cookie->lock);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
rtc-mc13783-fix-use-after-free-bug.patch
kcore-fix-test-for-end-of-list.patch
fscache-add-missing-unlock.patch
linux-next.patch
acpi_pad-processor_aggregator-name-too-long.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
em28xx-empia-em28xx-audio-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

