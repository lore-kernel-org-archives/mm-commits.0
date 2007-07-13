From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case-fix.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:33:56 -0700
Message-ID: <200707130733.l6D7XuGx005352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932799AbXGMHeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, neilb@suse.de


The patch titled
     knfsd: nfsd: use ip-address-based domain in secinfo case (fix)
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd: use ip-address-based domain in secinfo case (fix)
From: "J. Bruce Fields" <bfields@fieldses.org>

Could you fold the below into this patch?  Without this the server can
oops on attempts to access a filesystem not exported to the request's
source address!  Thanks to Olga Kornievskaia for the testing that found
this.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case-fix fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case-fix
+++ a/fs/nfsd/export.c
@@ -1264,7 +1264,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp)
+	if (exp && !IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
@@ -1294,7 +1294,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp)
+	if (exp && !IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
_

Patches currently in -mm which might be from bfields@fieldses.org are

git-vfs-lease-api.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case-fix.patch
