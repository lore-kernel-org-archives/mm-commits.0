From: akpm@linux-foundation.org
Subject: + drivers-usb-dwc3-ep0c-fix-sparc64-build.patch added to -mm tree
Date: Thu, 07 Mar 2013 15:14:23 -0800
Message-ID: <20130307231423.6CFC05A41EC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55126 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759998Ab3CGXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 18:14:25 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so105035qen.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 15:14:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbi@ti.com, gregkh@linuxfoundation.org


The patch titled
     Subject: drivers/usb/dwc3/ep0.c: fix sparc64 build
has been added to the -mm tree.  Its filename is
     drivers-usb-dwc3-ep0c-fix-sparc64-build.patch

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
Subject: drivers/usb/dwc3/ep0.c: fix sparc64 build

drivers/usb/dwc3/ep0.c: In function `__dwc3_ep0_do_control_data':
drivers/usb/dwc3/ep0.c:905: error: `typeof' applied to a bit-field

Looks like a gcc-3.4.5/sparc64 bug.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/dwc3/ep0.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/usb/dwc3/ep0.c~drivers-usb-dwc3-ep0c-fix-sparc64-build drivers/usb/dwc3/ep0.c
--- a/drivers/usb/dwc3/ep0.c~drivers-usb-dwc3-ep0c-fix-sparc64-build
+++ a/drivers/usb/dwc3/ep0.c
@@ -891,7 +891,8 @@ static void __dwc3_ep0_do_control_data(s
 				DWC3_TRBCTL_CONTROL_DATA);
 	} else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)
 			&& (dep->number == 0)) {
-		u32		transfer_size;
+		u32	transfer_size;
+		u32	maxpacket;
 
 		ret = usb_gadget_map_request(&dwc->gadget, &req->request,
 				dep->number);
@@ -902,8 +903,8 @@ static void __dwc3_ep0_do_control_data(s
 
 		WARN_ON(req->request.length > DWC3_EP0_BOUNCE_SIZE);
 
-		transfer_size = roundup(req->request.length,
-				(u32) dep->endpoint.maxpacket);
+		maxpacket = dep->endpoint.maxpacket;
+		transfer_size = roundup(req->request.length, maxpacket);
 
 		dwc->ep0_bounced = true;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch
include-linux-res_counterh-needs-errnoh.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
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
drivers-usb-dwc3-ep0c-fix-sparc64-build.patch
a-fix.patch

