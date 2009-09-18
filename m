From: akpm@linux-foundation.org
Subject: + include-linux-credh-fix-build-fix.patch added to -mm tree
Date: Fri, 18 Sep 2009 11:06:47 -0700
Message-ID: <200909181806.n8II6lji011063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243AbZIRSIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 14:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dhowells@redhat.com, jmorris@namei.org, serue@us.ibm.com


The patch titled
     cred: export creds_are_invalid
has been added to the -mm tree.  Its filename is
     include-linux-credh-fix-build-fix.patch

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
Subject: cred: export creds_are_invalid
From: Randy Dunlap <randy.dunlap@oracle.com>

creds_are_invalid() needs to be exported for use by modules:

ERROR: "creds_are_invalid" [fs/cachefiles/cachefiles.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cred.c~include-linux-credh-fix-build-fix kernel/cred.c
--- a/kernel/cred.c~include-linux-credh-fix-build-fix
+++ a/kernel/cred.c
@@ -799,6 +799,7 @@ bool creds_are_invalid(const struct cred
 #endif
 	return false;
 }
+EXPORT_SYMBOL(creds_are_invalid);
 
 /*
  * dump invalid credentials
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
include-linux-credh-fix-build-fix.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

