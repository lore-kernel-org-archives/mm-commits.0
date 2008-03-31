From: akpm@linux-foundation.org
Subject: + vmcoreinfo-add-page-flags-values.patch added to -mm tree
Date: Mon, 31 Mar 2008 15:39:20 -0700
Message-ID: <200803312239.m2VMdLQo029629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbYCaWj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 18:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, clameter@sgi.com, ebiederm@xmission.com


The patch titled
     vmcoreinfo: add page flags values
has been added to the -mm tree.  Its filename is
     vmcoreinfo-add-page-flags-values.patch

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
Subject: vmcoreinfo: add page flags values
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Add some values of page flags to the vmcoreinfo data.

The vmcoreinfo data has the minimum debugging information only for dump
filtering.  makedumpfile (dump filtering command) gets it to distinguish
unnecessary pages, and makedumpfile creates a small dumpfile.

An old makedumpfile (v1.2.4 or before) had assumed some values of page flags
internally, and this implementation could not follow the change of these
values.  For example, Christoph Lameter is changing these values by the
follwing patch: http://lkml.org/lkml/2008/2/29/463

So a new makedumpfile (v1.2.5) came to need these values and I created this
patch to let the kernel output them.

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kexec.c~vmcoreinfo-add-page-flags-values kernel/kexec.c
--- a/kernel/kexec.c~vmcoreinfo-add-page-flags-values
+++ a/kernel/kexec.c
@@ -1406,6 +1406,9 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
+	VMCOREINFO_NUMBER(PG_lru);
+	VMCOREINFO_NUMBER(PG_private);
+	VMCOREINFO_NUMBER(PG_swapcache);
 
 	arch_crash_save_vmcoreinfo();
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

vmcoreinfo-add-page-flags-values.patch

