From: akpm@osdl.org
Subject: + knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:42 -0800
Message-ID: <200612090009.kB909gNE010417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55618 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947588AbWLIAJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: don't inline nfsd4 compound op functions
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: don't inline nfsd4 compound op functions
From: J.Bruce Fields <bfields@fieldses.org>

The inlining contributes to bloating the stack of nfsd4_compound, and I want
to change the compound op functions to function pointers anyway.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   43 ++++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 25 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions
+++ a/fs/nfsd/nfs4proc.c
@@ -33,13 +33,6 @@
  *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- * Note: some routines in this file are just trivial wrappers
- * (e.g. nfsd4_lookup()) defined solely for the sake of consistent
- * naming.  Since all such routines have been declared "inline",
- * there shouldn't be any associated overhead.  At some point in
- * the future, I might inline these "by hand" to clean up a
- * little.
  */
 
 #include <linux/param.h>
@@ -161,7 +154,7 @@ do_open_fhandle(struct svc_rqst *rqstp, 
 }
 
 
-static inline __be32
+static __be32
 nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	   struct nfsd4_open *open)
 {
@@ -264,7 +257,7 @@ out:
 /*
  * filehandle-manipulating ops.
  */
-static inline __be32
+static __be32
 nfsd4_getfh(struct nfsd4_compound_state *cstate, struct svc_fh **getfh)
 {
 	if (!cstate->current_fh.fh_dentry)
@@ -274,7 +267,7 @@ nfsd4_getfh(struct nfsd4_compound_state 
 	return nfs_ok;
 }
 
-static inline __be32
+static __be32
 nfsd4_putfh(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	    struct nfsd4_putfh *putfh)
 {
@@ -285,7 +278,7 @@ nfsd4_putfh(struct svc_rqst *rqstp, stru
 	return fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
 }
 
-static inline __be32
+static __be32
 nfsd4_putrootfh(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate)
 {
 	__be32 status;
@@ -296,7 +289,7 @@ nfsd4_putrootfh(struct svc_rqst *rqstp, 
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_restorefh(struct nfsd4_compound_state *cstate)
 {
 	if (!cstate->save_fh.fh_dentry)
@@ -306,7 +299,7 @@ nfsd4_restorefh(struct nfsd4_compound_st
 	return nfs_ok;
 }
 
-static inline __be32
+static __be32
 nfsd4_savefh(struct nfsd4_compound_state *cstate)
 {
 	if (!cstate->current_fh.fh_dentry)
@@ -319,7 +312,7 @@ nfsd4_savefh(struct nfsd4_compound_state
 /*
  * misc nfsv4 ops
  */
-static inline __be32
+static __be32
 nfsd4_access(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_access *access)
 {
@@ -331,7 +324,7 @@ nfsd4_access(struct svc_rqst *rqstp, str
 			   &access->ac_supported);
 }
 
-static inline __be32
+static __be32
 nfsd4_commit(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_commit *commit)
 {
@@ -434,7 +427,7 @@ nfsd4_create(struct svc_rqst *rqstp, str
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_getattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_getattr *getattr)
 {
@@ -454,7 +447,7 @@ nfsd4_getattr(struct svc_rqst *rqstp, st
 	return nfs_ok;
 }
 
-static inline __be32
+static __be32
 nfsd4_link(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	   struct nfsd4_link *link)
 {
@@ -488,7 +481,7 @@ nfsd4_lookupp(struct svc_rqst *rqstp, st
 			   "..", 2, &cstate->current_fh);
 }
 
-static inline __be32
+static __be32
 nfsd4_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_lookup *lookup)
 {
@@ -497,7 +490,7 @@ nfsd4_lookup(struct svc_rqst *rqstp, str
 			   &cstate->current_fh);
 }
 
-static inline __be32
+static __be32
 nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	   struct nfsd4_read *read)
 {
@@ -527,7 +520,7 @@ out:
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_readdir(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_readdir *readdir)
 {
@@ -551,7 +544,7 @@ nfsd4_readdir(struct svc_rqst *rqstp, st
 	return nfs_ok;
 }
 
-static inline __be32
+static __be32
 nfsd4_readlink(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	       struct nfsd4_readlink *readlink)
 {
@@ -560,7 +553,7 @@ nfsd4_readlink(struct svc_rqst *rqstp, s
 	return nfs_ok;
 }
 
-static inline __be32
+static __be32
 nfsd4_remove(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_remove *remove)
 {
@@ -579,7 +572,7 @@ nfsd4_remove(struct svc_rqst *rqstp, str
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_rename(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_rename *rename)
 {
@@ -612,7 +605,7 @@ nfsd4_rename(struct svc_rqst *rqstp, str
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_setattr *setattr)
 {
@@ -639,7 +632,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	return status;
 }
 
-static inline __be32
+static __be32
 nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	    struct nfsd4_write *write)
 {
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

