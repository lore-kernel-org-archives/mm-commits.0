Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A04F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154623; cv=none; b=Nf/2elHt2bWprjTmadPuQjgKomxgfmg3KImYUMzfrxP/yjba0uyQL8cfOOcPQkXbmjV/wNwE2592mB9fs7MRYNbFeRdpjzKhn03LlCJYbH9xruvMXnva6HjFczp61QTykn/gdTpkreZyP4eMNdiINFPjK7AmInXuqbpwT85bSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154623; c=relaxed/simple;
	bh=gZyewfbgm60E5/OnnZfysGBOEc9Fm7PkXPxhmH4+L50=;
	h=Date:To:From:Subject:Message-Id; b=ULfLtU7I5KsQehxQtGmzlQeBsCpvwPMlvjAJVodmsEUw0DzMcCBhGPDDetrTitdspbKeX3LElt8spAVZM4HDt0Z1q8DK9+Y4mWe0uv4UtzbOWiS+3kkMH9BIw2bwLB8BjGA++a6HNazyObjVKt5pKCW9cpkwLgLYRIkRpKcSegg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ezkXg6TV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezkXg6TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F042C32786;
	Sun, 19 May 2024 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154623;
	bh=gZyewfbgm60E5/OnnZfysGBOEc9Fm7PkXPxhmH4+L50=;
	h=Date:To:From:Subject:From;
	b=ezkXg6TVJeXTMhn13kIWsush1wvFfIlbWV3P9GDwjT4nr8ky84KylrFCY3gse/HM0
	 JJR9oKdSovq1Mt9VQfSWhxyS+FGVORBwWc01DzeiPPSkKawLQeq4DXXQxR5q/lkSWv
	 yoynpgmxqRxZYXw9gGPOZ1PiQJZdbCwBiZVxPyqk=
Date: Sun, 19 May 2024 14:37:02 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-turn-on-wrestrict-by-default.patch removed from -mm tree
Message-Id: <20240519213703.5F042C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: turn on -Wrestrict by default
has been removed from the -mm tree.  Its filename was
     kbuild-turn-on-wrestrict-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kbuild: turn on -Wrestrict by default
Date: Mon, 15 Apr 2024 14:20:34 +0200

All known -Wrestrict warnings are addressed now, so don't disable the
warning any more.

Link: https://lkml.kernel.org/r/20240415122037.1983124-4-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-turn-on-wrestrict-by-default
+++ a/scripts/Makefile.extrawarn
@@ -98,7 +98,6 @@ else
 # Suppress them by using -Wno... except for W=1.
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
-KBUILD_CFLAGS += $(call cc-disable-warning, restrict)
 KBUILD_CFLAGS += $(call cc-disable-warning, packed-not-aligned)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
_

Patches currently in -mm which might be from arnd@arndb.de are


