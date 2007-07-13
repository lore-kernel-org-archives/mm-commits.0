From: akpm@linux-foundation.org
Subject: + knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:05 -0700
Message-ID: <200707130734.l6D7Y5dl005445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760784AbXGMHeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ketineni@us.ibm.com, bfields@citi.umich.edu, neilb@suse.de, uketinen@us.ibm.com


The patch titled
     knfsd: rpc: add gss krb5 and spkm3 oid values
has been added to the -mm tree.  Its filename is
     knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: rpc: add gss krb5 and spkm3 oid values
From: Usha Ketineni <ketineni@us.ibm.com>

Adds oid values to the gss_api mechanism structures.  On the NFSV4 server
side, these are required as part of the security triple (oid,qop,service)
information being sent in the response of the SECINFO operation.

Signed-off-by: Usha Ketineni <uketinen@us.ibm.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/gss_krb5_mech.c  |    1 +
 net/sunrpc/auth_gss/gss_spkm3_mech.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN net/sunrpc/auth_gss/gss_krb5_mech.c~knfsd-rpc-add-gss-krb5-and-spkm3-oid-values net/sunrpc/auth_gss/gss_krb5_mech.c
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c~knfsd-rpc-add-gss-krb5-and-spkm3-oid-values
+++ a/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -231,6 +231,7 @@ static struct pf_desc gss_kerberos_pfs[]
 static struct gss_api_mech gss_kerberos_mech = {
 	.gm_name	= "krb5",
 	.gm_owner	= THIS_MODULE,
+	.gm_oid		= {9, (void *)"\x2a\x86\x48\x86\xf7\x12\x01\x02\x02"},
 	.gm_ops		= &gss_kerberos_ops,
 	.gm_pf_num	= ARRAY_SIZE(gss_kerberos_pfs),
 	.gm_pfs		= gss_kerberos_pfs,
diff -puN net/sunrpc/auth_gss/gss_spkm3_mech.c~knfsd-rpc-add-gss-krb5-and-spkm3-oid-values net/sunrpc/auth_gss/gss_spkm3_mech.c
--- a/net/sunrpc/auth_gss/gss_spkm3_mech.c~knfsd-rpc-add-gss-krb5-and-spkm3-oid-values
+++ a/net/sunrpc/auth_gss/gss_spkm3_mech.c
@@ -217,6 +217,7 @@ static struct pf_desc gss_spkm3_pfs[] = 
 static struct gss_api_mech gss_spkm3_mech = {
 	.gm_name	= "spkm3",
 	.gm_owner	= THIS_MODULE,
+	.gm_oid		= {7, "\053\006\001\005\005\001\003"},
 	.gm_ops		= &gss_spkm3_ops,
 	.gm_pf_num	= ARRAY_SIZE(gss_spkm3_pfs),
 	.gm_pfs		= gss_spkm3_pfs,
_

Patches currently in -mm which might be from ketineni@us.ibm.com are

knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch
