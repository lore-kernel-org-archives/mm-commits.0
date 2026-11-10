Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291212;
	b=EF6A2+gl2Z87rCRInmFdxFAvoyfLuUW98WiIHJ7Ff0+T0L4SEqnyeNQeYlp/nwIiKTGL
	 XtPH20kf7Y0fmpAd0iui04p1Mq2eZD0OhR+M4/HYiNCGcJtzxQ/VkrUqsiHWJEirMH9pq
	 hjiK2JpQRNIJReG9B9jILGxk9fQGxK+8PHtIVDtP5y6rmNL4c8z+w9PhowCyUeJykyDQb
	 MVhLgefrzt+fNdoUL/WQP7bd0rW6o9gkU/gb5C6Ee+b60tP/7jVh/NBjeegmtJHxfTUwh
	 MikQKAnEsgfW+ZU4xReBp+70h2d2kZ/1DtRZYAcPRbRL2DE2vm6k15IQR7hv6yLPiBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291212;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Hqy+b+2cF/6PTIVSqoSueApn/tAkn+baxF9FzOb1P3E=;
	b=jL5CzVEwnx2K+Z48O68MbBuxybV9ylNyK4GWxvUiykXrI2fjdz/kBUEZ5+ZbZSdjFEEy
	 Xa9Y9+NO9yg9GavESPL7TNLzkfZHL9Q1b5R5NUoX0kYDIkwxKQ88c/LgWP8lun/lnSOKV
	 7K/icDtoVxxbOoePqhZEDAPgRg3Sg2+Ygys6zpItwfmhJrh5nTRJih4R+PJnasLQhzFJf
	 dGdWz7vSpUdZqwKSg5zH25h2KPhJMXX5s/rK6KRRGLKINua8vE6PWQUBbwlKnAWSHayXA
	 5okuCEVh/Ed+o0tcM0GxgE4NljqJdaEURIueZ2MakrELQyO4pcvtN13zk55iFs26ygQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2GZN0r54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7419606A325
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2GZN0r54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132911F008A1;
	Tue, 10 Nov 2026 06:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794291211;
	bh=Hqy+b+2cF/6PTIVSqoSueApn/tAkn+baxF9FzOb1P3E=;
	h=Date:To:From:Subject;
	b=2GZN0r54YHJPU6hnDz0B+CPT3/2oKgC/NA9rcVVA/HA9brZgcn9/Bh590yyGe2VUA
	 o+8Kx378JycCAjBitn4dnuZM1NArNdVUQQoMF48O5IzfHQp1lYFoydV7bMRb1T5323
	 wpvJNcjfWYmBvxBMG7tnbztrYiFF6rWoiXGbDNS4=
Date: Mon, 09 Nov 2026 22:13:30 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,
	hao.ge@linux.dev,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch added to mm-unstable branch
Message-Id: <20261110061331.132911F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kselftest: alloc_tag: use the ll64 types on powerpc64
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch

This patch will later appear in the mm-unstable branch at
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
From: Sasha Levin <sashal@kernel.org>
Subject: kselftest: alloc_tag: use the ll64 types on powerpc64
Date: Tue, 03 Nov 2026 10:54:54 -0500

On powerpc64 __u64 is an unsigned long unless __SANE_USERSPACE_TYPES__ is
defined, so printing and scanning the __u64 fields with %llu warns:

  allocinfo_ioctl_test.c:93:73: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 2 has type '__u64' {aka 'long unsigned int'} [-Wformat=]

Define __SANE_USERSPACE_TYPES__, as other selftests do.

Link: https://lore.kernel.org/20261103155454.534649-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c~kselftest-alloc_tag-use-the-ll64-types-on-powerpc64
+++ a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define __SANE_USERSPACE_TYPES__
 
 /* kselftest for allocinfo ioctl
  * allocinfo ioctl retrieves allocinfo data through ioctl
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

