Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CBA13B58B
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750630687; cv=none; b=Q6lFJ2zU3F3MDHuDOgP+yBal89KkKPqrj+168Or3XsLmvXeQPJBRGZy0NrB6fziL+6oTb2bsROpHezrfSxcm2SDYkrNase2APd3Sor8SvVJJd+hBPQ+R2LaNQgp2YN77xk3ZRuOGMANpgMbTyTUs1wDso3V8auwgwi2D7TNGhgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750630687; c=relaxed/simple;
	bh=ukFHDL5qk3cea63tQlPu7pwf2zdJbj/1vQA/hsmcG+U=;
	h=Date:To:From:Subject:Message-Id; b=g05FmKR3ndcLXJQ9DUwS8XKW/m0Yv+Ky8VK1vFGMxuyKorH35guGfN+WKc0eGGgUTrvtxIuziEGr6Y4BcYkbDUz7sZy1D2C9BJnm49Wn4DTo5sSB8ktY6tLzDA2C3AJ9mJxsqqAnjG+EfDB9XQN9UKvPQHT3FLpjMMoir2teiZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIMbbuuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIMbbuuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C374C4CEE3;
	Sun, 22 Jun 2025 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750630687;
	bh=ukFHDL5qk3cea63tQlPu7pwf2zdJbj/1vQA/hsmcG+U=;
	h=Date:To:From:Subject:From;
	b=aIMbbuuJj97rUdGUXoKPCG1aFFlAXLKDHhpNYqpcR2h3iXJgoZrwocjoC24HxwFjh
	 E6c+z+1iOQLDosrbhf2ZhRUSrXKmaL9Aj6e1J6KAicvMBLpVYcPwzAkH0sECpW9/rR
	 +PKW2GO7DeDXbUhIm3xEbgOD7THYxuS6Gs2iqdZY=
Date: Sun, 22 Jun 2025 15:18:06 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crashdump-add-config_keys-dependency.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622221807.1C374C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crashdump: add CONFIG_KEYS dependency
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crashdump-add-config_keys-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crashdump-add-config_keys-dependency.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: crashdump: add CONFIG_KEYS dependency
Date: Fri, 20 Jun 2025 13:21:22 +0200

The dm_crypt code fails to build without CONFIG_KEYS:

kernel/crash_dump_dm_crypt.c: In function 'restore_dm_crypt_keys_to_thread_keyring':
kernel/crash_dump_dm_crypt.c:105:9: error: unknown type name 'key_ref_t'; did you mean 'key_ref_put'?

There is a mix of 'select KEYS' and 'depends on KEYS' in Kconfig,
so there is no single obvious solution here, but generally using 'depends on'
makes more sense and is less likely to cause dependency loops.

Link: https://lkml.kernel.org/r/20250620112140.3396316-1-arnd@kernel.org
Fixes: 62f17d9df692 ("crash_dump: retrieve dm crypt keys in kdump kernel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/Kconfig.kexec~crashdump-add-config_keys-dependency
+++ a/kernel/Kconfig.kexec
@@ -134,6 +134,7 @@ config CRASH_DM_CRYPT
 	depends on KEXEC_FILE
 	depends on CRASH_DUMP
 	depends on DM_CRYPT
+	depends on KEYS
 	help
 	  With this option enabled, user space can intereact with
 	  /sys/kernel/config/crash_dm_crypt_keys to make the dm crypt keys
_

Patches currently in -mm which might be from arnd@arndb.de are

crashdump-add-config_keys-dependency.patch
lib-test_hmm-reduce-stack-usage.patch

