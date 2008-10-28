From: akpm@linux-foundation.org
Subject: - gfs2-sparse-annotation-of-gl-gl_spin.patch removed from -mm tree
Date: Tue, 28 Oct 2008 12:06:58 -0700
Message-ID: <200810281906.m9SJ6w8r023688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbYJ1THk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 15:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2: sparse annotation of gl->gl_spin
has been removed from the -mm tree.  Its filename was
     gfs2-sparse-annotation-of-gl-gl_spin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gfs2: sparse annotation of gl->gl_spin
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/gfs2/glock.c:308:5: warning: context problem in 'do_promote': '_spin_unlock' expected different context
fs/gfs2/glock.c:308:5:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:529:2: warning: context problem in 'do_xmote': '_spin_unlock' expected different context
fs/gfs2/glock.c:529:2:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:925:3: warning: context problem in 'add_to_queue': '_spin_unlock' expected different context
fs/gfs2/glock.c:925:3:    context '*gl+28': wanted >= 1, got 0

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glock.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/gfs2/glock.c~gfs2-sparse-annotation-of-gl-gl_spin fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~gfs2-sparse-annotation-of-gl-gl_spin
+++ a/fs/gfs2/glock.c
@@ -293,6 +293,8 @@ static void gfs2_holder_wake(struct gfs2
  */
 
 static int do_promote(struct gfs2_glock *gl)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh, *tmp;
@@ -511,6 +513,8 @@ static unsigned int gfs2_lm_lock(struct 
  */
 
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
@@ -576,6 +580,8 @@ static inline struct gfs2_holder *find_f
  */
 
 static void run_queue(struct gfs2_glock *gl, const int nonblock)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	struct gfs2_holder *gh = NULL;
 
@@ -877,6 +883,8 @@ void gfs2_print_dbg(struct seq_file *seq
  */
 
 static inline void add_to_queue(struct gfs2_holder *gh)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mips-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
sh-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
sparc-use-the-new-byteorder-headers.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
m68knommu-use-the-new-byteorder-headers.patch
cris-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
memstick-annotate-endianness-of-attribute-structs.patch

