Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA3823DC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104498; cv=none; b=OIYtZ0F1eyz8/Mr8ZCPVDFDUlOzwaTG7TE/xaezYMaqVheknGjKmpjIgK4a5/lcY3cDTw1Vc2MRbXPGxqOAG+dyfYOgnet1GuvnvhC2ddG+5Mgwh3hyms+8HBZyuKqMRcpyXiqcqpY4fruBfg2jtb4JrE4McEE4nFiVTvh7Nrbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104498; c=relaxed/simple;
	bh=baPrmFgRpRs3MHXuXKF4ndqqhdQfcGnkfOiibRa9v38=;
	h=Date:To:From:Subject:Message-Id; b=dxkW+NDkKgxwuTbh9oOmVtKU4nPXUP1JvyUDdNKYop+avIvcHOz7YKZAEZAWWuujoDQIvc3zNH5CIM5NNKhnUCzGHEKe/OOZHlhT//uZ+mEsN0fsFcCDTSAHZMW3U4t72L6Z6jwoLS3W2UjuvHPYhSYw/fE2zNHYiSnTTIPugtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moggCb4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moggCb4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4A8C113CD;
	Fri, 26 Apr 2024 04:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104498;
	bh=baPrmFgRpRs3MHXuXKF4ndqqhdQfcGnkfOiibRa9v38=;
	h=Date:To:From:Subject:From;
	b=moggCb4XIInyGSa9Sq2UC0xBdwjee/DRZIIJaZbc9rEpvsVqzbk6FCS/48Lop6gTe
	 ipHWveRSdycog8EIZidTsdpsYWfSaTZ0aBnwOYGcQFXo7TEiF5r8nMPvYjFwxdtjtq
	 7rLOywSp+mfUAdMsZm4urVVsaqGZQ3VaROebBI4M=
Date: Thu, 25 Apr 2024 21:08:17 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,keescook@chromium.org,justinstitt@google.com,ebiederm@xmission.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-exec-make-binaries-position-independent.patch removed from -mm tree
Message-Id: <20240426040818.5C4A8C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: exec: make binaries position independent
has been removed from the -mm tree.  Its filename was
     selftests-exec-make-binaries-position-independent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


