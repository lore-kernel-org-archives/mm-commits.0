Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4964D23BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248753; cv=none; b=rd4jycbktrTNtyVaOro79pgv6s5zSiqS3ghOMzWyFxy5aAnci7+Jn2ERmCGIGttaOcj9iccyUkb+lloT0nPP1a/oAvmggODN2flYbZ9gkjBRz39+gmH9I8vhFrMee+DxsWiNqdKf0ItilVoUX6MIx9MZWIvG3Jh7aN84DKSz5kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248753; c=relaxed/simple;
	bh=DbibQRoNmIpKkaVu6C7r5NOCs+NVMScNwuQKw6UpEck=;
	h=Date:To:From:Subject:Message-Id; b=ba7g6Bpg623tG0piEsDEYIWHz6XcaS6xHE6KbcQ1265bCCcpnhGQuEly/4FN3/jAN475sxQHDirKPENahVC8mNFaYPzQTasy+xIf5qiBVADhF33ctt2BQQG5GYgE16Zpr44f8hr98aO1Ld4n8GkZA48blFtZu8Kaj4xc3IJdVAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZjQdQCKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZjQdQCKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F2BC4CEC2;
	Mon,  2 Sep 2024 03:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248752;
	bh=DbibQRoNmIpKkaVu6C7r5NOCs+NVMScNwuQKw6UpEck=;
	h=Date:To:From:Subject:From;
	b=ZjQdQCKZ3ChCOvveHVRuuOZkfLa6gIjSgFpRNshkDXAngdAuxFoYJ5h7gcCkJSKA/
	 +K1x5OmlcU/1cV83LIS00POlG5H4JvuNodxIDRSImKfhbmTBI2PmsZ3Smu9M0iZWwY
	 qnE1cuKWbo4IF8cPj6jGtznUmdAtoTGw9KPEHY4E=
Date: Sun, 01 Sep 2024 20:45:52 -0700
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,mhiramat@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_objpool-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240902034552.B3F2BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_objpool: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-test_objpool-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib: test_objpool: add missing MODULE_DESCRIPTION() macro
Date: Mon, 15 Jul 2024 07:18:56 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_objpool.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240715-md-lib-test_objpool-v2-1-5a2b9369c37e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Matt Wu <wuqiang.matt@bytedance.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_objpool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_objpool.c~lib-test_objpool-add-missing-module_description-macro
+++ a/lib/test_objpool.c
@@ -687,4 +687,5 @@ static void __exit ot_mod_exit(void)
 module_init(ot_mod_init);
 module_exit(ot_mod_exit);
 
-MODULE_LICENSE("GPL");
\ No newline at end of file
+MODULE_DESCRIPTION("Test module for lockless object pool");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


