Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD132217F33
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955214; cv=none; b=QkfrAkECg/DADVXcoZaEbvnN45BTHt/mw6JBRn3pRYaW3A805wQ5PjGKfKDZ7G96WhOcZs+FHA2s6MeHtWllKYt4CN2QzlH7qIUP5rdnj6hoY4KnnZHTsho7x6CVO/Lc2UoUUt53o4FHf/L4WSt+y3VNCQmRhbS0sTOGAs7a3R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955214; c=relaxed/simple;
	bh=p/0rLkMONmpDpoT3uwNUXquD8rkFCpTBxFD7izm6/is=;
	h=Date:To:From:Subject:Message-Id; b=X5alvVzvRJx5pC5kquH89VFvjymCvpWYRMUPFPdlBKYWNGnbV/UCbDaNDg/mZ9oE+ahfZLM9h5kcs7ioJlVYOfalZs13sjHXZQ97IUaac8L/D6nMs1sNMJVPmDy2koK6cLdS0UbL3HzUN4H5l4dQBtFcwWilxYLZy9Yd8/y0bX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEMV+J5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEMV+J5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C0EC16AAE;
	Wed, 21 Jan 2026 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768955214;
	bh=p/0rLkMONmpDpoT3uwNUXquD8rkFCpTBxFD7izm6/is=;
	h=Date:To:From:Subject:From;
	b=ZEMV+J5jgWfVg8kdd49svjgmgxJiEmqOA9UKVscEMFkdRzWEnOotHvww+hzHQWkP9
	 t5R3j2sHSaRAdxdbNTlbFqZkCy0llvba2wGpNsincUsujRR5jYp7WqSUaFqErSWeNY
	 sxwr3gAYdBKsTk0wbkgYkZ7914uXZa5i5DixU+oE=
Date: Tue, 20 Jan 2026 16:26:53 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,hch@infradead.org,cem@kernel.org,andy@kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xfs-adjust-handling-of-a-few-numerical-mount-options.patch removed from -mm tree
Message-Id: <20260121002654.39C0EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xfs: adjust handling of a few numerical mount options
has been removed from the -mm tree.  Its filename was
     xfs-adjust-handling-of-a-few-numerical-mount-options.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: xfs: adjust handling of a few numerical mount options
Date: Thu, 8 Jan 2026 19:52:16 +0300

Prefer recently introduced 'memvalue()' over an ad-hoc
'suffix_kstrtoint()' and 'suffix_kstrtoull()' to parse and basically
validate the values passed via 'logbsize', 'allocsize', and
'max_atomic_write' mount options, and reject non-power-of-two values
passed via the first and second one early in 'xfs_fs_parse_param()' rather
than in 'xfs_fs_validate_params()'.

Link: https://lkml.kernel.org/r/20260108165216.1054625-2-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_super.c |  127 +++++++++----------------------------------
 1 file changed, 29 insertions(+), 98 deletions(-)

--- a/fs/xfs/xfs_super.c~xfs-adjust-handling-of-a-few-numerical-mount-options
+++ a/fs/xfs/xfs_super.c
@@ -1319,77 +1319,6 @@ static const struct super_operations xfs
 	.show_stats		= xfs_fs_show_stats,
 };
 
-static int
-suffix_kstrtoint(
-	const char	*s,
-	unsigned int	base,
-	int		*res)
-{
-	int		last, shift_left_factor = 0, _res;
-	char		*value;
-	int		ret = 0;
-
-	value = kstrdup(s, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	if (kstrtoint(value, base, &_res))
-		ret = -EINVAL;
-	kfree(value);
-	*res = _res << shift_left_factor;
-	return ret;
-}
-
-static int
-suffix_kstrtoull(
-	const char		*s,
-	unsigned int		base,
-	unsigned long long	*res)
-{
-	int			last, shift_left_factor = 0;
-	unsigned long long	_res;
-	char			*value;
-	int			ret = 0;
-
-	value = kstrdup(s, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	if (kstrtoull(value, base, &_res))
-		ret = -EINVAL;
-	kfree(value);
-	*res = _res << shift_left_factor;
-	return ret;
-}
-
 static inline void
 xfs_fs_warn_deprecated(
 	struct fs_context	*fc,
@@ -1427,8 +1356,8 @@ xfs_fs_parse_param(
 {
 	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
-	int			size = 0;
-	int			opt;
+	int			opt, ret;
+	unsigned long long	val;
 
 	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
 
@@ -1444,8 +1373,19 @@ xfs_fs_parse_param(
 		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
+		ret = memvalue(param->string, &val);
+		if (ret)
+			return ret;
+		if (val != 0 &&
+		    (val < XLOG_MIN_RECORD_BSIZE ||
+		     val > XLOG_MAX_RECORD_BSIZE ||
+		     !is_power_of_2(val))) {
+			xfs_warn(parsing_mp,
+				 "invalid logbsize %llu: not a power-of-two in [%u..%u]",
+				 val, XLOG_MIN_RECORD_BSIZE, XLOG_MAX_RECORD_BSIZE);
 			return -EINVAL;
+		}
+		parsing_mp->m_logbsize = val;
 		return 0;
 	case Opt_logdev:
 		kfree(parsing_mp->m_logname);
@@ -1460,9 +1400,18 @@ xfs_fs_parse_param(
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
-		if (suffix_kstrtoint(param->string, 10, &size))
+		ret = memvalue(param->string, &val);
+		if (ret)
+			return ret;
+		if (val < (1ULL << XFS_MIN_IO_LOG) ||
+		    val > (1ULL << XFS_MAX_IO_LOG) ||
+		    !is_power_of_2(val)) {
+			xfs_warn(parsing_mp,
+				 "invalid allocsize %llu: not a power-of-two in [%u..%u]",
+				 val, 1 << XFS_MIN_IO_LOG, 1 << XFS_MAX_IO_LOG);
 			return -EINVAL;
-		parsing_mp->m_allocsize_log = ffs(size) - 1;
+		}
+		parsing_mp->m_allocsize_log = ffs(val) - 1;
 		parsing_mp->m_features |= XFS_FEAT_ALLOCSIZE;
 		return 0;
 	case Opt_grpid:
@@ -1570,12 +1519,13 @@ xfs_fs_parse_param(
 		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
 		return 0;
 	case Opt_max_atomic_write:
-		if (suffix_kstrtoull(param->string, 10,
-				     &parsing_mp->m_awu_max_bytes)) {
+		ret = memvalue(param->string, &val);
+		if (ret) {
 			xfs_warn(parsing_mp,
  "max atomic write size must be positive integer");
-			return -EINVAL;
+			return ret;
 		}
+		parsing_mp->m_awu_max_bytes = val;
 		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
@@ -1629,25 +1579,6 @@ xfs_fs_validate_params(
 		return -EINVAL;
 	}
 
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return -EINVAL;
-	}
-
-	if (xfs_has_allocsize(mp) &&
-	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
-	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
-		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch
ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch

