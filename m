From: akpm@linux-foundation.org
Subject: - nfsd-validate-filehandle-type-in-fsid_source.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:08:13 -0700
Message-ID: <200708081908.l78J8D5W025854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760428AbXHHTRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, bfields@fieldses.org, lcapitulino@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nfsd: validate filehandle type in fsid_source
has been removed from the -mm tree.  Its filename was
     nfsd-validate-filehandle-type-in-fsid_source.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: validate filehandle type in fsid_source
From: Neil Brown <neilb@suse.de>

fsid_source decided where to get the 'fsid' number to return for a GETATTR
based on the type of filehandle.  It can be from the device, from the fsid,
or from the UUID.

It is possible for the filehandle to be inconsistent with the export
information, so make sure the export information actually has the info
implied by the value returned by fsid_source.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN fs/nfsd/nfsfh.c~nfsd-validate-filehandle-type-in-fsid_source fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~nfsd-validate-filehandle-type-in-fsid_source
+++ a/fs/nfsd/nfsfh.c
@@ -566,13 +566,23 @@ enum fsid_source fsid_source(struct svc_
 	case FSID_DEV:
 	case FSID_ENCODE_DEV:
 	case FSID_MAJOR_MINOR:
-		return FSIDSOURCE_DEV;
+		if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
+		    & FS_REQUIRES_DEV)
+			return FSIDSOURCE_DEV;
+		break;
 	case FSID_NUM:
-		return FSIDSOURCE_FSID;
-	default:
 		if (fhp->fh_export->ex_flags & NFSEXP_FSID)
 			return FSIDSOURCE_FSID;
-		else
-			return FSIDSOURCE_UUID;
+		break;
+	default:
+		break;
 	}
+	/* either a UUID type filehandle, or the filehandle doesn't
+	 * match the export.
+	 */
+	if (fhp->fh_export->ex_flags & NFSEXP_FSID)
+		return FSIDSOURCE_FSID;
+	if (fhp->fh_export->ex_uuid)
+		return FSIDSOURCE_UUID;
+	return FSIDSOURCE_DEV;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

clean-up-duplicate-includes-in-net-sunrpc.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
