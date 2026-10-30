Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333706;
	b=eLR8DQAis1gPxlQ6eNlOXBvxc6Gc96lDCcKHjzf4YmzNItHXTgKJSTUIu+/8hJXBHXw0
	 U0hvSvzcWRUe/AHgbXPhyKxGaHC6RJJJKRl2jnjH4gW9+bpekGxYYk0YQ7bYl2xqTh9FI
	 BSriX2wIlf/zxajy5kSh/oLSbnUxmB57ajfjbEoOwj2SgIN9O+X4F5JvWP2W14+kFEIMF
	 heMG9nqzh9sRJug3XTJfbgE/To+us2a5ozuvjLh08KratwQckoQKnUWJLbDGcdcNw53Dv
	 axWxgp0TrVoaR7sNS+8uPExLKsQfISqO8XdvJzlTWbsOI31FVPAsBJwhIhU5Wn0acyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333706;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EjiZcSDy5pcc/8Svznhodm7WL14r/8JCFHs59qqaj2Y=;
	b=tOaEXcW0hInh/vCOaqFHfJJp5bHW54tun1QbFwIHTWkIiLJC2jJFoR54QeTnD5a8Ecfd
	 Q/AKhFcLlSOlXakhPa7ol2QNjuAJ7ZatdQci1XkIDuuwW6DsYGkfS651ppx5wVdpop9PY
	 tb8+1mvBYMLPoQRSfqqt43SrqHt6CHMNk1eSZ4WLnlSzrziQjc5W7zP7nj8J+nXZFL9g5
	 XWQ0LjQggtiAg7HhUfcXrM8JHy558pXOVU6m9TnWKkCqrtpOQaoXc7MeSIoCemeGv4FBM
	 81s9caUvaiEwwrxRCIGGXXd71lGX+EiXJ/1cnF4TWiGnekl5+B+mz/txKG9335k1b2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w4V6MBiS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1C6606A324
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w4V6MBiS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CAB1F000C1;
	Fri, 30 Oct 2026 04:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333705;
	bh=EjiZcSDy5pcc/8Svznhodm7WL14r/8JCFHs59qqaj2Y=;
	h=Date:To:From:Subject;
	b=w4V6MBiSacTc+zSMo+QMuV20EXV/aDU3d2tn5lsPyLabMhIsNVvkard1Y8XFCpfDE
	 Z+b1YnAPVgXpvMkfTZ2Q37mZCdxIWvTlks98bu3z/pXxBQh6HMkfOuPI7zUcuIVdWs
	 +wx3eURNM+Kkteu62suBJCXS9EiFyDSy82UlwSZM=
Date: Thu, 29 Oct 2026 21:15:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,osalvador@suse.de,
	david@kernel.org,chihsheng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memory-hotplug-use-id-u-instead-of-uid-for-root-check.patch added to mm-new branch
Message-Id: <20261030041505.41CAB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/memory-hotplug: use $(id -u) instead of $UID for root check
has been added to the -mm mm-new branch.  Its filename is
     selftests-memory-hotplug-use-id-u-instead-of-uid-for-root-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memory-hotplug-use-id-u-instead-of-uid-for-root-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Darren Chang <chihsheng@google.com>
Subject: selftests/memory-hotplug: use $(id -u) instead of $UID for root check
Date: Thu, 22 Oct 2026 05:22:45 +0000

$UID is a bash-specific variable and is not defined in other shells such
as Android's /system/bin/sh (mksh) or POSIX sh. When running this test
on environments without bash (e.g. Android), $UID is unset and
'[ $UID != 0 ]' expands to '[ != 0 ]', causing a syntax error.

Replace $UID with "$(id -u)" so the root privilege check works across
different shells.

Link: https://lore.kernel.org/20261022052245.1138709-2-chihsheng@google.com
Signed-off-by: Darren Chang <chihsheng@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 tools/testing/selftests/memory-hotplug/mem-on-off-test.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh~selftests-memory-hotplug-use-id-u-instead-of-uid-for-root-check
+++ a/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
@@ -10,7 +10,7 @@ prerequisite()
 {
 	msg="skip all tests:"
 
-	if [ $UID != 0 ]; then
+	if [ "$(id -u)" -ne 0 ]; then
 		echo $msg must be run as root >&2
 		exit $ksft_skip
 	fi
_

Patches currently in -mm which might be from chihsheng@google.com are

selftests-cpu-hotplug-use-id-u-instead-of-uid-for-root-check.patch
selftests-memory-hotplug-use-id-u-instead-of-uid-for-root-check.patch

