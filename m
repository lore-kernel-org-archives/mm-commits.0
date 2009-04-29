From: akpm@linux-foundation.org
Subject: + nfsd-use-c99-struct-initializers.patch added to -mm tree
Date: Wed, 29 Apr 2009 14:39:58 -0700
Message-ID: <200904292139.n3TLdwfY008333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbZD2Vkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 17:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bfields@fieldses.org, neilb@suse.de


The patch titled
     nfsd: use C99 struct initializers
has been added to the -mm tree.  Its filename is
     nfsd-use-c99-struct-initializers.patch

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
Subject: nfsd: use C99 struct initializers
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate 56 sparse warnings like this one:

fs/nfsd/nfs4xdr.c:1331:15: warning: obsolete array initializer, use C99 syntax

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4xdr.c |  112 ++++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~nfsd-use-c99-struct-initializers fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~nfsd-use-c99-struct-initializers
+++ a/fs/nfsd/nfs4xdr.c
@@ -1328,64 +1328,64 @@ static nfsd4_dec nfsd4_dec_ops[] = {
 };
 
 static nfsd4_dec nfsd41_dec_ops[] = {
-	[OP_ACCESS]		(nfsd4_dec)nfsd4_decode_access,
-	[OP_CLOSE]		(nfsd4_dec)nfsd4_decode_close,
-	[OP_COMMIT]		(nfsd4_dec)nfsd4_decode_commit,
-	[OP_CREATE]		(nfsd4_dec)nfsd4_decode_create,
-	[OP_DELEGPURGE]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_DELEGRETURN]	(nfsd4_dec)nfsd4_decode_delegreturn,
-	[OP_GETATTR]		(nfsd4_dec)nfsd4_decode_getattr,
-	[OP_GETFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_LINK]		(nfsd4_dec)nfsd4_decode_link,
-	[OP_LOCK]		(nfsd4_dec)nfsd4_decode_lock,
-	[OP_LOCKT]		(nfsd4_dec)nfsd4_decode_lockt,
-	[OP_LOCKU]		(nfsd4_dec)nfsd4_decode_locku,
-	[OP_LOOKUP]		(nfsd4_dec)nfsd4_decode_lookup,
-	[OP_LOOKUPP]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_NVERIFY]		(nfsd4_dec)nfsd4_decode_verify,
-	[OP_OPEN]		(nfsd4_dec)nfsd4_decode_open,
-	[OP_OPENATTR]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_OPEN_CONFIRM]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_OPEN_DOWNGRADE]	(nfsd4_dec)nfsd4_decode_open_downgrade,
-	[OP_PUTFH]		(nfsd4_dec)nfsd4_decode_putfh,
-	[OP_PUTPUBFH]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_PUTROOTFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_READ]		(nfsd4_dec)nfsd4_decode_read,
-	[OP_READDIR]		(nfsd4_dec)nfsd4_decode_readdir,
-	[OP_READLINK]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_REMOVE]		(nfsd4_dec)nfsd4_decode_remove,
-	[OP_RENAME]		(nfsd4_dec)nfsd4_decode_rename,
-	[OP_RENEW]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_RESTOREFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_SAVEFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_SECINFO]		(nfsd4_dec)nfsd4_decode_secinfo,
-	[OP_SETATTR]		(nfsd4_dec)nfsd4_decode_setattr,
-	[OP_SETCLIENTID]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_SETCLIENTID_CONFIRM](nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_VERIFY]		(nfsd4_dec)nfsd4_decode_verify,
-	[OP_WRITE]		(nfsd4_dec)nfsd4_decode_write,
-	[OP_RELEASE_LOCKOWNER]	(nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_ACCESS]		= (nfsd4_dec)nfsd4_decode_access,
+	[OP_CLOSE]		= (nfsd4_dec)nfsd4_decode_close,
+	[OP_COMMIT]		= (nfsd4_dec)nfsd4_decode_commit,
+	[OP_CREATE]		= (nfsd4_dec)nfsd4_decode_create,
+	[OP_DELEGPURGE]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_DELEGRETURN]	= (nfsd4_dec)nfsd4_decode_delegreturn,
+	[OP_GETATTR]		= (nfsd4_dec)nfsd4_decode_getattr,
+	[OP_GETFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_LINK]		= (nfsd4_dec)nfsd4_decode_link,
+	[OP_LOCK]		= (nfsd4_dec)nfsd4_decode_lock,
+	[OP_LOCKT]		= (nfsd4_dec)nfsd4_decode_lockt,
+	[OP_LOCKU]		= (nfsd4_dec)nfsd4_decode_locku,
+	[OP_LOOKUP]		= (nfsd4_dec)nfsd4_decode_lookup,
+	[OP_LOOKUPP]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_NVERIFY]		= (nfsd4_dec)nfsd4_decode_verify,
+	[OP_OPEN]		= (nfsd4_dec)nfsd4_decode_open,
+	[OP_OPENATTR]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_OPEN_CONFIRM]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_OPEN_DOWNGRADE]	= (nfsd4_dec)nfsd4_decode_open_downgrade,
+	[OP_PUTFH]		= (nfsd4_dec)nfsd4_decode_putfh,
+	[OP_PUTPUBFH]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_PUTROOTFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_READ]		= (nfsd4_dec)nfsd4_decode_read,
+	[OP_READDIR]		= (nfsd4_dec)nfsd4_decode_readdir,
+	[OP_READLINK]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_REMOVE]		= (nfsd4_dec)nfsd4_decode_remove,
+	[OP_RENAME]		= (nfsd4_dec)nfsd4_decode_rename,
+	[OP_RENEW]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_RESTOREFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_SAVEFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_SECINFO]		= (nfsd4_dec)nfsd4_decode_secinfo,
+	[OP_SETATTR]		= (nfsd4_dec)nfsd4_decode_setattr,
+	[OP_SETCLIENTID]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_SETCLIENTID_CONFIRM]= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_VERIFY]		= (nfsd4_dec)nfsd4_decode_verify,
+	[OP_WRITE]		= (nfsd4_dec)nfsd4_decode_write,
+	[OP_RELEASE_LOCKOWNER]	= (nfsd4_dec)nfsd4_decode_notsupp,
 
 	/* new operations for NFSv4.1 */
-	[OP_BACKCHANNEL_CTL]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_BIND_CONN_TO_SESSION](nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_EXCHANGE_ID]	(nfsd4_dec)nfsd4_decode_exchange_id,
-	[OP_CREATE_SESSION]	(nfsd4_dec)nfsd4_decode_create_session,
-	[OP_DESTROY_SESSION]	(nfsd4_dec)nfsd4_decode_destroy_session,
-	[OP_FREE_STATEID]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_GET_DIR_DELEGATION]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_GETDEVICEINFO]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_GETDEVICELIST]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_LAYOUTCOMMIT]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_LAYOUTGET]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_LAYOUTRETURN]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_SECINFO_NO_NAME]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_SEQUENCE]		(nfsd4_dec)nfsd4_decode_sequence,
-	[OP_SET_SSV]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_TEST_STATEID]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_WANT_DELEGATION]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_DESTROY_CLIENTID]	(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_RECLAIM_COMPLETE]	(nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_BACKCHANNEL_CTL]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_BIND_CONN_TO_SESSION]= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_EXCHANGE_ID]	= (nfsd4_dec)nfsd4_decode_exchange_id,
+	[OP_CREATE_SESSION]	= (nfsd4_dec)nfsd4_decode_create_session,
+	[OP_DESTROY_SESSION]	= (nfsd4_dec)nfsd4_decode_destroy_session,
+	[OP_FREE_STATEID]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_GET_DIR_DELEGATION]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_GETDEVICEINFO]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_GETDEVICELIST]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_LAYOUTCOMMIT]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_LAYOUTGET]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_LAYOUTRETURN]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_SECINFO_NO_NAME]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_SEQUENCE]		= (nfsd4_dec)nfsd4_decode_sequence,
+	[OP_SET_SSV]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_TEST_STATEID]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_WANT_DELEGATION]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_DESTROY_CLIENTID]	= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_RECLAIM_COMPLETE]	= (nfsd4_dec)nfsd4_decode_notsupp,
 };
 
 struct nfsd4_minorversion_ops {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
ecryptfs-fix-printk-format-warning.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
nfsd-use-c99-struct-initializers.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
kernel-doc-restrict-syntax-for-private-and-public.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

