From: akpm@linux-foundation.org
Subject: + drivers-rapidio-rio-scanc-make-functions-static.patch added to
 -mm tree
Date: Tue, 11 Jun 2013 16:02:58 -0700
Message-ID: <51b7aca2.WoT2KAbzxr7Dtf1G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3FKXC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 19:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Alexandre.Bounine@idt.com, fengguang.wu@intel.com

Subject: + drivers-rapidio-rio-scanc-make-functions-static.patch added to -mm tree
To: fengguang.wu@intel.com,Alexandre.Bounine@idt.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 16:02:58 -0700


The patch titled
     Subject: drivers/rapidio/rio-scan.c: make functions static
has been added to the -mm tree.  Its filename is
     drivers-rapidio-rio-scanc-make-functions-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: drivers/rapidio/rio-scan.c: make functions static

sparse warnings:

drivers/rapidio/rio-scan.c:1143:5: sparse: symbol 'rio_enum_mport' was not declared. Should it be static?
drivers/rapidio/rio-scan.c:1246:5: sparse: symbol 'rio_disc_mport' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-make-functions-static drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-make-functions-static
+++ a/drivers/rapidio/rio-scan.c
@@ -1141,7 +1141,7 @@ static void rio_pw_enable(struct rio_mpo
  * link, then start recursive peer enumeration. Returns %0 if
  * enumeration succeeds or %-EBUSY if enumeration fails.
  */
-int rio_enum_mport(struct rio_mport *mport, u32 flags)
+static int rio_enum_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	int rc = 0;
@@ -1256,7 +1256,7 @@ static void rio_build_route_tables(struc
  * peer discovery. Returns %0 if discovery succeeds or %-EBUSY
  * on failure.
  */
-int rio_disc_mport(struct rio_mport *mport, u32 flags)
+static int rio_disc_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	unsigned long to_end;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
fs-fs-writebackc-make-wb_do_writeback-as-static.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
fat-additions-to-support-fat_fallocate-fix.patch
drivers-rapidio-rio-scanc-make-functions-static.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

