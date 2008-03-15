From: akpm@linux-foundation.org
Subject: + nfsd-fix-oops-on-access-from-high-numbered-ports.patch added to -mm tree
Date: Fri, 14 Mar 2008 17:50:35 -0700
Message-ID: <200803150050.m2F0oZHS026932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYCOAvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 20:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de, stable@kernel.org, xhejtman@ics.muni.cz


The patch titled
     nfsd: fix oops on access from high-numbered ports
has been added to the -mm tree.  Its filename is
     nfsd-fix-oops-on-access-from-high-numbered-ports.patch

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
Subject: nfsd: fix oops on access from high-numbered ports
From: J. Bruce Fields <bfields@citi.umich.edu>

This bug was always here, but before my commit 6fa02839bf9412e18e77 ("recheck
for secure ports in fh_verify"), it could only be triggered by failure of a
kmalloc().  After that commit it could be triggered by a client making a
request from a non-reserved port for access to an export marked "secure". 
(Exports are "secure" by default.)

The result is a struct svc_export with a reference count one to low, resulting
in likely oopses next time the export is accessed.

The reference counting here is not straightforward; a later patch will
clean up fh_verify().

Thanks to Lukas Hejtmanek for the bug report and followup.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfsfh.c~nfsd-fix-oops-on-access-from-high-numbered-ports fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~nfsd-fix-oops-on-access-from-high-numbered-ports
+++ a/fs/nfsd/nfsfh.c
@@ -232,6 +232,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 		fhp->fh_dentry = dentry;
 		fhp->fh_export = exp;
 		nfsd_nr_verified++;
+		cache_get(&exp->h);
 	} else {
 		/*
 		 * just rechecking permissions
@@ -241,6 +242,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 		dprintk("nfsd: fh_verify - just checking\n");
 		dentry = fhp->fh_dentry;
 		exp = fhp->fh_export;
+		cache_get(&exp->h);
 		/*
 		 * Set user creds for this exportpoint; necessary even
 		 * in the "just checking" case because this may be a
@@ -252,8 +254,6 @@ fh_verify(struct svc_rqst *rqstp, struct
 		if (error)
 			goto out;
 	}
-	cache_get(&exp->h);
