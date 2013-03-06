From: akpm@linux-foundation.org
Subject: + dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:12:36 -0800
Message-ID: <20130306211236.6DBFE31C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:63835 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CFVMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:12:37 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so916724ves.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:12:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben@decadent.org.uk, stable@vger.kernel.org, tmhikaru@gmail.com, zhenzhong.duan@oracle.com


The patch titled
     Subject: dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix
has been added to the -mm tree.  Its filename is
     dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix

Cc: <stable@vger.kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Tim McGrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -460,7 +460,7 @@ static int __init smbios_present(const c
 			dmi_ver = 0x0206;
 			break;
 		}
-		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
+		return memcmp(p + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

