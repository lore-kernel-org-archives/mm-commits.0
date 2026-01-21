Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF85352942
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966661; cv=none; b=UKhv9K1k0y0CQIMOVjPG2HpGP8xW+ldiVyQh+eWFgQ2FfX6bFpRPCq8tBMQkdPRFMccbX3RwQIvqd8hs3z9GXu1m/DgKxnD6FTtPtP4fsNDkg3fSkdVabVFV6QRoG+ngNfRj1byiCrCEbbnGHeIBaFtxZXG4RSNpS058vQeZwqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966661; c=relaxed/simple;
	bh=5NLjGfxq+K81I4FhbDp3Di3qwf3g1WGCOMBdzTzxzr8=;
	h=Date:To:From:Subject:Message-Id; b=cCXgT01ou6REAWA1XgLEqYBsojqnSR0JtCxkQkL72xUXHJUJP5xwmjDmETahQ8IC0JnirTu3ImBvj4SsB5AY7QKUEDnsbiIHwU6PVUCdD+hpc7SaqsQ/vv9pCP10ie8AzNWNIC6CCrw9SO1314qnLsZMahESIfaoS2M4MpoHQ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g3QaBqgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g3QaBqgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A29EC16AAE;
	Wed, 21 Jan 2026 03:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966660;
	bh=5NLjGfxq+K81I4FhbDp3Di3qwf3g1WGCOMBdzTzxzr8=;
	h=Date:To:From:Subject:From;
	b=g3QaBqgkIutpOvY6GlBk/XsGqtOF9yzR/ZSjEHifoHQRMSVGmTlHlP14cO8eT90IB
	 5H3Hhamn3VvD2cZMp2t3lDAfrfzC8N69phfT/uQLQXBDjTOWRGvNOvbbjdYSBn25c+
	 ymVYgaBuxSoCpG9dfsu52aZ3iHZxsgn9aUkXaM40=
Date: Tue, 20 Jan 2026 19:37:39 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@kernel.org,rppt@kernel.org,mingo@kernel.org,link@vivo.com,lillian@star-ark.net,kernel@pengutronix.de,guoweikang.kernel@gmail.com,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,alexander.shishkin@linux.intel.com,a.fatoum@pengutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch removed from -mm tree
Message-Id: <20260121033740.7A29EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

This patch was dropped because it was folded into init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
Date: Mon Jan 12 12:11:32 PM PST 2026

move ramdisk_execute_command_set into __initdata

Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lillian Berry <lillian@star-ark.net>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
+++ a/init/main.c
@@ -162,7 +162,7 @@ static size_t initargs_offs;
 
 static char *execute_command;
 static char *ramdisk_execute_command = "/init";
-static bool ramdisk_execute_command_set;
+static bool __initdata ramdisk_execute_command_set;
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

