From: akpm@linux-foundation.org
Subject: + revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:37:35 -0800
Message-ID: <20121219223736.5113E200057__29124.3425490849$1355956694$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42581 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2LSWhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:37:39 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so137668fae.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:37:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, LW@KARO-electronics.de, holler@ahsoftware.de, stable@vger.kernel.org, vpalatin@chromium.org


The patch titled
     Subject: revert "rtc: recycle id when unloading a rtc driver"
has been added to the -mm tree.  Its filename is
     revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "rtc: recycle id when unloading a rtc driver"

Revert

commit 2830a6d20139df2198d63235df7957712adb28e5
Author: Vincent Palatin <vpalatin@chromium.org>
Date:   Thu Oct 4 17:13:52 2012 -0700

    rtc: recycle id when unloading a rtc driver


We already perform the ida_simple_remove() in rtc_device_release(), whi=
ch
is an appropriate place.  2830a6d20 ("rtc: recycle id when unloading a =
rtc
driver") caused the kernel to emit

	ida_remove called for id=3D0 which is not allocated.

warnings when rtc_device_release() tries to release an alread-released =
ID.

Let's restore things to their previous state and then work out why
Vincent's kernel wasn't calling rtc_device_release() - presumably a bug=
 in
a specific sub-driver.

Reported-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
Acked-by: Alexander Holler <holler@ahsoftware.de>
Cc: Vincent Palatin <vpalatin@chromium.org>
Cc: <stable@vger.kernel.org>		[3.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/class.c~revert-rtc-recycle-id-when-unloading-a-rt=
c-driver drivers/rtc/class.c
--- a/drivers/rtc/class.c~revert-rtc-recycle-id-when-unloading-a-rtc-dr=
iver
+++ a/drivers/rtc/class.c
@@ -244,7 +244,6 @@ void rtc_device_unregister(struct rtc_de
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops =3D NULL;
-		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.p=
atch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attr=
ibutes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
