From: akpm@linux-foundation.org
Subject: - cifs-primitive-is-not-an-asn1-class.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:22 -0700
Message-ID: <200807252304.m6PN4MeI004040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbYGYXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: primitive is not an asn1 class
has been removed from the -mm tree.  Its filename was
     cifs-primitive-is-not-an-asn1-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -494,7 +494,7 @@ decode_negTokenInit(unsigned char *secur
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

origin.patch
linux-next.patch
git-unionfs.patch

