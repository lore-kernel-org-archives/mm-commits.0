Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D642EC095
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894181; cv=none; b=fmPMk0vavOfHbq5G2mrVNkNQO077zM0v5cBtAfNtKha1Aju/DEQIGpkslctOMU2jhmHiFmQwrNgPr1C8T0Q7+EZ0c4YC/+W+0Bzt7J/A/5A4haonpNW2fVD5K3WdnF+IwPQFlTnln+1ho8jpvCiaT9m/q6kIfRyOfZzJLosPa8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894181; c=relaxed/simple;
	bh=WibJCeuHqOsRtWdZ+j44Hc7FaLdKe3Lfr6Ms6rjhYRQ=;
	h=Date:To:From:Subject:Message-Id; b=JO+L5fFjv4RfKkoTPlR3SWJcANfmGkpOZGd7s1CdvtykRGpxqdIVAp459k9oLS4l/2Eze02Nl5DOXbvRe6xNLtYiKQwJ87SNawk2bPOYm0D+8w0oyn9ic44IbzwCqecBUIqLokooSVCKOdqPrk10J+dnwzRDeCsiLCNNfkbsv/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xHX9Qmvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xHX9Qmvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0886C116C6;
	Thu,  8 Jan 2026 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767894179;
	bh=WibJCeuHqOsRtWdZ+j44Hc7FaLdKe3Lfr6Ms6rjhYRQ=;
	h=Date:To:From:Subject:From;
	b=xHX9Qmvq/+20Re8JYpXI2HHr5FchcsVPALapCQHkVegZZm10KEDJv0Hhqt+P5RJXv
	 XrIForPL4J/zGfTfJqD4l4yK+p8yup1cAc+uxF++vHqIe5DezGTQ33opKWmzUnubGs
	 gw6KFzLU1ZoKon/cbLRhn8vRr5bqQnkcf/C4mqvg=
Date: Thu, 08 Jan 2026 09:42:59 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,hch@infradead.org,cem@kernel.org,andy@kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-adjust-handling-of-a-few-numerical-mount-options.patch added to mm-nonmm-unstable branch
Message-Id: <20260108174259.C0886C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xfs: adjust handling of a few numerical mount options
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xfs-adjust-handling-of-a-few-numerical-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-adjust-handling-of-a-few-numerical-mount-options.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -1310,77 +1310,6 @@ static const struct super_operations xfs
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
@@ -1418,8 +1347,8 @@ xfs_fs_parse_param(
 {
 	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
-	int			size = 0;
-	int			opt;
+	int			opt, ret;
+	unsigned long long	val;
 
 	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
 
@@ -1435,8 +1364,19 @@ xfs_fs_parse_param(
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
@@ -1451,9 +1391,18 @@ xfs_fs_parse_param(
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
@@ -1561,12 +1510,13 @@ xfs_fs_parse_param(
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
@@ -1620,25 +1570,6 @@ xfs_fs_validate_params(
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
lib-introduce-simple-error-checking-wrapper-for-memparse.patch
xfs-adjust-handling-of-a-few-numerical-mount-options.patch

