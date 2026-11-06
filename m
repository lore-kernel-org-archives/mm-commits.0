Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934526;
	b=RRT8npdI9yFocuLu/G0HiRBz0NqAFUtOWcx4xGIpxDkXn7URBsvLSHS8lpd4pzyKTrvg
	 5rBIq/MjK6wHYSVlDcjYU67uRfTQT9jQ6D8RnlL4Jyl5q+KPczzDcMnNoKGqjcD5gDlC4
	 WnWxlQCA9rz9XH072X+XLWx5L+rsmoZgi/JQ9lQZJzbrXMZGw8np3FirA8R6JpE3D0SuF
	 +zRY9qeTDfGEEHvcZq8ihg5DI8R3rQgVkdNIA5KEWlBQuQrSE8Tup/B4lccN8k0AuS64y
	 Tr++3GwcL/4TG04T6o+VWu/fxdTQ8v8+BZNjkMOpxYQQotCROnX/KqatQbCJnwV3Vbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934526;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MmF7buvWywFPohpjuTBBxzgs35UKk8ENkFVXAfC+slU=;
	b=2UOBDU8M+DLQ/T9LM07RwAEfxzwaeoxxIqfb17ecMc2BKxB4a+sKLZJeKePwdX40AkPh
	 h4OxOS67dj3fpEsat4n7AktL1aai6Kj/t7ZDvwu1keuG4m1apaRezRVmGRLtf7EMe5O3v
	 OPiJSLQoACs4Fj43Kh4kRXdw5x1Eh+AverZV2uYztMClZGIJd6X5BCukZa9v3MTBWi8wy
	 fXrI7hUNI3Fb7EZAh/bInNKS4ij4vMIdqbJIUgUwsV0hqtcrrp8Ff46wEtJfyYiv+g2eg
	 5GStTor7l+yJkwV+Rg+fzD0EGZrWfsSCype36sWqGdu9prfbjYd/mm2Vf4wfI5NhYpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lRJX2l9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959EB606A326
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lRJX2l9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6671F0089F;
	Fri,  6 Nov 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934526;
	bh=MmF7buvWywFPohpjuTBBxzgs35UKk8ENkFVXAfC+slU=;
	h=Date:To:From:Subject;
	b=lRJX2l9ECi0ZNUiarwT1N9izVwBudFu0FHVAILMo5WVEIOxrMPJJllXBKvFubFmq+
	 TgAzsQfp+Z0X6YCh8O6eK8B71w39FaQDvCsJGePQxcH0YAKdf/izq6e15xiogU2uJ3
	 GAhdv7Bl+76NQGvkpsot5zCsg8bSxXuUZvrcrrOw=
Date: Thu, 05 Nov 2026 19:08:45 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,jm5905938@gmail.com,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch added to mm-new branch
Message-Id: <20261106030846.1D6671F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

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
From: SJ Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
Date: Thu, 05 Nov 2026 18:05:58 -0800

Update DAMON usage document for the newly added age_ms DAMOS core filter
type.  Add an explanation of how the age range for the filter can be
specified by the user.

Link: https://lore.kernel.org/20261106020559.98352-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -559,6 +559,9 @@ For ``probe_hits_wsum`` type, you can sp
 hits weighted sum value for the filter to ``min`` and ``max`` files,
 respectively.
 
+For ``age_ms`` type, you can specify the minimum and maximum age in
+milliseconds for the filter to ``min`` and ``max`` files, respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

