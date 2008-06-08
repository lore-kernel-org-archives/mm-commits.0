From: akpm@linux-foundation.org
Subject: + cifs-primitive-is-not-an-asn1-class.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:18:14 -0700
Message-ID: <200806081918.m58JIEWk016407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbYFHTXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, sfrench@us.ibm.com


The patch titled
     cifs: primitive is not an asn1 class
has been added to the -mm tree.  Its filename is
     cifs-primitive-is-not-an-asn1-class.patch

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
Subject: cifs: primitive is not an asn1 class
From: Chris Wright <chrisw@sous-sol.org>

When verifying the decoded header before decoding the object identifier
(expecting a SPNEGO pseudo-mechanism oid), the test to verify it is a
primitive encoding is compared against the asn1 class.  Primitive is not a
class.  This brings check in line with similar check for krb/ntlmssp oid.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/asn1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/asn1.c~cifs-primitive-is-not-an-asn1-class fs/cifs/asn1.c
--- a/fs/cifs/asn1.c~cifs-primitive-is-not-an-asn1-class
+++ a/fs/cifs/asn1.c
@@ -480,7 +480,7 @@ decode_negTokenInit(unsigned char *secur
 		/*      remember to free obj->oid */
 		rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
 		if (rc) {
-			if ((tag == ASN1_OJI) && (cls == ASN1_PRI)) {
+			if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
 				rc = asn1_oid_decode(&ctx, end, &oid, &oidlen);
 				if (rc) {
 					rc = compare_oid(oid, oidlen,
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch
devscgroup-relax-task-to-dev_cgroup-conversion.patch
linux-next.patch
cifs-primitive-is-not-an-asn1-class.patch
git-unionfs.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

