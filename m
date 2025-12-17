Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE611DF254
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765991969; cv=none; b=Bk71VWXWm6UkNFXk0qQg4Wf9Taq8B3DmojJGNEa3RK2dGmAb+Z2Xc4oBxeA6PeRhbFFzovXZjLaARUc/LkI/ZjXIcb8vKu/At7uleZ+Mg4CoT6QZ1WRsaK/qecauSi5HumnYmq7YGgk4b921kHOA/ajyZ3uPekD30rGGrquGuKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765991969; c=relaxed/simple;
	bh=+9s4m6GdH7Wc7IK5eiVvzQ9xmmMQEp1Am/TR4CXsMjw=;
	h=Date:To:From:Subject:Message-Id; b=KsEYnBEtNyLriEtW09g2caFraY44ig8HvuYfmXm4MAwfIw1qa7ebk636VVlXqs3z4jvuRfx03LQOLp5AnMWPbCodjqTAgrO0XChqh+SXKz29LDnP/pQGBc6gnVyJLbyf1z9chv2vve4oh/3myeT01Ixm8Feh6LgUHlPMm++7tq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eVbv9jmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eVbv9jmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91342C4CEF5;
	Wed, 17 Dec 2025 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765991968;
	bh=+9s4m6GdH7Wc7IK5eiVvzQ9xmmMQEp1Am/TR4CXsMjw=;
	h=Date:To:From:Subject:From;
	b=eVbv9jmS+nF3LmXRjU7B5NTIO+xrZevnOebRvwEGvrGfA2YiI/kBttCmgM6F/a69D
	 xG5LvE5nmT08LC6PkRup16ghqBRY/8O8BG/J3X74Q0qkio95vF673vH5xNTvgMgqHZ
	 cV+qFU3yHeGng5v36d5VnZjMh6c5C8Ie/ubCuW9Q=
Date: Wed, 17 Dec 2025 09:19:27 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,mingo@kernel.org,mhiramat@kernel.org,link@vivo.com,lillian@star-ark.net,guoweikang.kernel@gmail.com,francesco@valla.it,chenhuacai@kernel.org,brauner@kernel.org,alexander.shishkin@linux.intel.com,sameekshasankpal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] init-mark-envp_init-as-static.patch removed from -mm tree
Message-Id: <20251217171928.91342C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: mark envp_init as static
has been removed from the -mm tree.  Its filename was
     init-mark-envp_init-as-static.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Subject: init: mark envp_init as static
Date: Sat, 29 Nov 2025 00:46:50 +0530

Sparse reports a warning that 'envp_init' has no prior declaration:

  warning: symbol 'envp_init' was not declared. Should it be static?

The variable is only used within init/main.c and does not need external
linkage.  Mark it as static to limit its scope and fix the sparse warning.

Link: https://lkml.kernel.org/r/20251128191650.18821-1-sameekshasankpal@gmail.com
Signed-off-by: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lillian Berry <lillian@star-ark.net>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mark-envp_init-as-static
+++ a/init/main.c
@@ -191,7 +191,7 @@ static int __init set_reset_devices(char
 __setup("reset_devices", set_reset_devices);
 
 static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 static bool __init obsolete_checksetup(char *line)
_

Patches currently in -mm which might be from sameekshasankpal@gmail.com are


