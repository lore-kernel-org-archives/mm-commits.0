Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092A62033A
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736562234; cv=none; b=Kr2c9EW/ZrLtgEc4tPYGQbBgYrZHauQ3M0sfdyTJzoasbE7SIJkznZYGuvwTetdh/XEeFOhrnXgvXzImCdqGh2lrQxR74Dih49yoo7pPQjkCkutdNvODIgfrkDfTXlTkZiyTm8Jg+kIOzMO6tKT2J/+YPVCYBUIoYq/dulnH8Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736562234; c=relaxed/simple;
	bh=R5AJyvTJQUXPDwR7eN9h03LZShPFuQtdcpZ0jzoK1HY=;
	h=Date:To:From:Subject:Message-Id; b=MH1cnyiAgGBiO1xclCqBwbW+9VTGK/F15o335cTHBVK4TTWnvhqyMySbh9f79n6ZDSTBtVF1w0j9u2ULiJc/D7Epv7Ar8MhOhe2uuTNEknUBp+CihBJEm15Bp1nkK5zuqyq25C408uXB+uocYggBdWaKb+tOApYPmk6siHQ3LKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rH522Cyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rH522Cyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671E7C4CED6;
	Sat, 11 Jan 2025 02:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736562233;
	bh=R5AJyvTJQUXPDwR7eN9h03LZShPFuQtdcpZ0jzoK1HY=;
	h=Date:To:From:Subject:From;
	b=rH522CyrIQdDYU7EPsUEhu+XPM2VMfN6Gdh6dB/uR51bfbc9kEKpZ+V//ozW0p+BK
	 rWr8oiYwT46aEWCV4nnV+uSYo6JbO5G2PfYkCkakUbfEcNdB3B9VLnKPniYCJAZdOH
	 8Xfe6gXCV1HmozwIocicLz9HhQpPW7sRI9Sm6220=
Date: Fri, 10 Jan 2025 18:23:52 -0800
To: mm-commits@vger.kernel.org,gissf1@gmail.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch added to mm-nonmm-unstable branch
Message-Id: <20250111022353.671E7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: correct return value kernel-doc descriptions for sufile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: correct return value kernel-doc descriptions for sufile
Date: Fri, 10 Jan 2025 10:01:46 +0900

Similar to the previous changes to fix return value descriptions, this
fixes the format of the return value descriptions of functions for
sufile-related functions, eliminating a dozen warnings emitted by the
kernel-doc script.

Link: https://lkml.kernel.org/r/20250110010530.21872-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: "Brian G ." <gissf1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |  102 ++++++++++++++++---------------------------
 fs/nilfs2/sufile.h |   16 ++----
 2 files changed, 45 insertions(+), 73 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile
+++ a/fs/nilfs2/sufile.c
@@ -155,17 +155,13 @@ unsigned long nilfs_sufile_get_ncleanseg
  * of successfully modified segments from the head is stored in the
  * place @ndone points to.
  *
- * Return Value: On success, zero is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - Given segment usage is in hole block (may be returned if
- *            @create is zero)
- *
- * %-EINVAL - Invalid segment usage number
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid segment usage number
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Given segment usage is in hole block (may be returned if
+ *		  @create is zero)
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 			 int create, size_t *ndone,
@@ -272,10 +268,7 @@ int nilfs_sufile_update(struct inode *su
  * @start: minimum segment number of allocatable region (inclusive)
  * @end: maximum segment number of allocatable region (inclusive)
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-ERANGE - invalid segment region
+ * Return: 0 on success, or %-ERANGE if segment range is invalid.
  */
 int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
 {
@@ -300,17 +293,14 @@ int nilfs_sufile_set_alloc_range(struct
  * @sufile: inode of segment usage file
  * @segnump: pointer to segment number
  *
- * Description: nilfs_sufile_alloc() allocates a clean segment.
- *
- * Return Value: On success, 0 is returned and the segment number of the
- * allocated segment is stored in the place pointed by @segnump. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
+ * Description: nilfs_sufile_alloc() allocates a clean segment, and stores
+ * its segment number in the place pointed to by @segnump.
  *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - No clean segment left.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No clean segment left.
  */
 int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 {
@@ -610,16 +600,13 @@ int nilfs_sufile_set_segment_usage(struc
  * @sufile: inode of segment usage file
  * @sustat: pointer to a structure of segment usage statistics
  *
- * Description: nilfs_sufile_get_stat() returns information about segment
- * usage.
- *
- * Return Value: On success, 0 is returned, and segment usage information is
- * stored in the place pointed by @sustat. On error, one of the following
- * negative error codes is returned.
+ * Description: nilfs_sufile_get_stat() retrieves segment usage statistics
+ * and stores them in the location pointed to by @sustat.
  *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
@@ -683,16 +670,12 @@ void nilfs_sufile_do_set_error(struct in
  * @start: start segment number (inclusive)
  * @end: end segment number (inclusive)
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid number of segments specified
- *
- * %-EBUSY - Dirty or active segments are present in the range
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Dirty or active segments are present in the range.
+ * * %-EINVAL	- Invalid number of segments specified.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_sufile_truncate_range(struct inode *sufile,
 				       __u64 start, __u64 end)
@@ -787,16 +770,12 @@ out:
  * @sufile: inode of segment usage file
  * @newnsegs: new number of segments
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - Enough free space is not left for shrinking
- *
- * %-EBUSY - Dirty or active segments exist in the region to be truncated
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Dirty or active segments exist in the region to be truncated.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- Enough free space is not left for shrinking.
  */
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 {
@@ -939,14 +918,11 @@ ssize_t nilfs_sufile_get_suinfo(struct i
  * segment usage accordingly. Only the fields indicated by the sup_flags
  * are updated.
  *
- * Return Value: On success, 0 is returned. On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid values in input (segment number, flags or nblocks).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 				unsigned int supsz, size_t nsup)
@@ -1073,7 +1049,7 @@ ssize_t nilfs_sufile_set_suinfo(struct i
  * and start+len is rounded down. For each clean segment blkdev_issue_discard
  * function is invoked.
  *
- * Return Value: On success, 0 is returned or negative error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 {
--- a/fs/nilfs2/sufile.h~nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile
+++ a/fs/nilfs2/sufile.h
@@ -95,8 +95,7 @@ static inline int nilfs_sufile_freev(str
  * @nsegs: size of @segnumv array
  * @ndone: place to store the number of cancelled segments
  *
- * Return Value: On success, 0 is returned. On error, a negative error codes
- * is returned.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
 					    __u64 *segnumv, size_t nsegs,
@@ -114,14 +113,11 @@ static inline int nilfs_sufile_cancel_fr
  * Description: nilfs_sufile_set_error() marks the segment specified by
  * @segnum as erroneous. The error segment will never be used again.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid segment usage number.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid segment usage number.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch
nilfs2-protect-access-to-buffers-with-no-active-references.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-ioctl-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-the-rest.patch
nilfs2-add-missing-return-value-kernel-doc-descriptions.patch
nilfs2-revise-the-return-value-description-style-for-consistency.patch

