From: akpm@osdl.org
Subject: - knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:16:53 -0800
Message-ID: <200612140616.kBE6Grak002272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbWLNGR1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: don't inline nfsd4 compound op functions
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 18 insertions(+), 25 deletions(-)

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


