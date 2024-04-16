Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CB32943C
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713296214; cv=none; b=X6f2ELxVgjWy/ag9pmp2t+L7e2zhvAo9OUtEvvJMXKIIZhw3MFZMp9g7S1Ybc/Ahv//7C3qdnT5x71QOGQIAGeN4Ox+/b6EQh0vn++sekFdGqsJWYYYYLkzGcXIbmrzPcv734vvexjs/n1FdSaZutSgBNrqo/7Va8TZcjtd1UXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713296214; c=relaxed/simple;
	bh=9ekF5bwXjlEXOg5zbsZjP+UVpFm/GP9eCYq8djR0hJk=;
	h=Date:To:From:Subject:Message-Id; b=XFpNzVePYMrg5kOdtTqIj/rs6i+urK2mIPO3hQLSn8X5QrNLfvq0dXiis1dhu+fNYQ67eyV9sK/PrpPptYz0NPpYQGXhx7A0j+XzShkGwrWLiOLlMHBs6SIaHzu8nUSotGzC2S507X01o3/CYyb1zpwF4Ib6zmGqJpK7Owp8hpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kClf+obN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kClf+obN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999C6C113CE;
	Tue, 16 Apr 2024 19:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713296213;
	bh=9ekF5bwXjlEXOg5zbsZjP+UVpFm/GP9eCYq8djR0hJk=;
	h=Date:To:From:Subject:From;
	b=kClf+obNScl81iWd1PNx+KtMePA7mPJrwxYz1lBNrybaP9UWpESJwJhGGAcbtNo2m
	 jHtliTcn5U0BgLU5IAKxDobv7hQ28RT4D5x6FNm5yB4EPyOAinuhK9Up+Pxgq+zSVG
	 8EvzctRHEfilht8rXQZF//x2/MUEkxCw1yOX4ud0=
Date: Tue, 16 Apr 2024 12:36:53 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,keescook@chromium.org,justinstitt@google.com,ebiederm@xmission.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-exec-make-binaries-position-independent.patch added to mm-nonmm-unstable branch
Message-Id: <20240416193653.999C6C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: exec: make binaries position independent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-exec-make-binaries-position-independent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-exec-make-binaries-position-independent.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: exec: make binaries position independent
Date: Tue, 16 Apr 2024 20:28:29 +0500

The -static overrides the -pie and binaries aren't position independent
anymore.  Use -static-pie instead which would produce a static and
position independent binary.  This has been caught by clang's warnings:

  clang: warning: argument unused during compilation: '-pie'
  [-Wunused-command-line-argument]

Tested with both gcc and clang after this change.

Link: https://lkml.kernel.org/r/20240416152831.3199999-1-usama.anjum@collabora.com
Fixes: 4d1cd3b2c5c1 ("tools/testing/selftests/exec: fix link error")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/exec/Makefile~selftests-exec-make-binaries-position-independent
+++ a/tools/testing/selftests/exec/Makefile
@@ -29,8 +29,8 @@ $(OUTPUT)/execveat.denatured: $(OUTPUT)/
 	cp $< $@
 	chmod -x $@
 $(OUTPUT)/load_address_4096: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie -static $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -static-pie $< -o $@
 $(OUTPUT)/load_address_2097152: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie -static $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -static-pie $< -o $@
 $(OUTPUT)/load_address_16777216: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie -static $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -static-pie $< -o $@
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-exec-make-binaries-position-independent.patch

