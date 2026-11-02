Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793594265;
	b=1InUsMLRipLckvuz5qpCZ4JB6tYKEYVYh8Z9hZ8tUD6qfYHeXvTfsSR0DdA//NtSsh9j
	 4+rSr1zmqmf9nurHjQI7Ezx1nCyYmSk6zq5njRJHWkW/jy0ZiL4MwzL+NPArrH/Ihi8M/
	 skoNvWdZkjPaN/zXvV8R7Dj8TjWgsxzw/6oUQHYBTsGyh+zSlYPqhLIHcwO1Lr1KyeVt+
	 nH+c/EwNZqNj610KKE9txj6KI8z1YXJ8tP4t69mks5/ydgz6ewwh1i7KMe7TGWWk5hvLw
	 4A4A1pJzJ2ivRFj4g0e9cC6AD3xNJ3VyJsXQQF+qM1hn2+lbKO7tNHtgHEhKBaqJ83A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793594265;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wyE5WpKu9WoYNEuM/FyTeOv3oikhbEt85yU4/tAz0l8=;
	b=KPZn7/fOTVaotDK3C6z0Eq51/BNw531MBWLLDR5YMSofucQ00ZraESuNa2gwT9H/OqlH
	 zNvXwE28nC8lR5BHTBhQhAuah3dJ48PZuxhTou6ExiAiaRhF7l0cSq5AB1j9BpJ39Meti
	 3lkX9Ru41XWqkMnNj6Kf/JbSWjJnKmNLgElVxHKINiMplc9uDo2BMsjELyM8rnGcQmmU5
	 HtEAwdwnE3iqNWJlOfMtn/Oyv4nL8XeJsKJU5n0GIjn4NpnJW4IiQUTEKufowvgJC7P6U
	 tyjGUIT6o9Hc1FretXCO3FoTEAy31D29gCRGufHQpaGD/t9V0RY0XzgKJv5FFZv4i+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e1THfHMd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C190C606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 04:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e1THfHMd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F1C1F000C1;
	Mon,  2 Nov 2026 04:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793594264;
	bh=wyE5WpKu9WoYNEuM/FyTeOv3oikhbEt85yU4/tAz0l8=;
	h=Date:To:From:Subject;
	b=e1THfHMdA6u4W5vwqMifVwMlNGAAxe+civDn+P3TdRuD01jfYBM7cM+hX23LLc9mo
	 /hsjqt2ZSHy9wu0C7dphbg32T66G4rcV9w+Xfq8EpTJwy5awYfF865FE9Ge5TOiNlC
	 tJzseJhSpcULZurfQdSRcVP/1IB62KiRlxVU0I0g=
Date: Sun, 01 Nov 2026 20:37:43 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,
	joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,
	kolyshkin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch added to mm-nonmm-unstable branch
Message-Id: <20261102043744.46F1C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: don't suggest kstrto<type> in userspace code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

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
From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: checkpatch: don't suggest kstrto<type> in userspace code
Date: Thu, 22 Oct 2026 15:44:23 -0700

The SSCANF_TO_KSTRTO check suggests using kstrto<type> instead of a
single-variable sscanf(). These helpers are kernel-only and are not
available to userspace code under tools/, so the suggestion can not be
followed there.

Use is_userspace() to skip the check for such files.

Link: https://lore.kernel.org/20261022224426.2756960-5-kolyshkin@gmail.com
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-suggest-kstrtotype-in-userspace-code
+++ a/scripts/checkpatch.pl
@@ -7224,8 +7224,8 @@ sub process {
 			     "unchecked sscanf return value\n" . "$here\n$stat_real\n");
 		}
 
-# check for simple sscanf that should be kstrto<foo>
-		if ($perl_version_ok &&
+# check for simple sscanf that should be kstrto<foo> (not available in userspace)
+		if ($perl_version_ok && !is_userspace($realfile) &&
 		    defined $stat &&
 		    $line =~ /\bsscanf\b/) {
 			my $lc = $stat =~ tr@\n@@;
_

Patches currently in -mm which might be from kolyshkin@gmail.com are

checkpatch-is_userspace-exclude-kernel-code-under-tools.patch
checkpatch-dont-warn-about-enosys-in-userspace-code.patch
checkpatch-dont-warn-about-bug-in-userspace-code.patch
checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

