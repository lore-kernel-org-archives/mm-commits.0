Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF1C37269A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028777; cv=none; b=NEcskLEwGLIV3Fl9EK5MPlWE1m3n+vv6oCGSxJVjN61Dgcx1S6SDPWOz5PaPbQV9qJiLfneA3qA9DBBo66gGql+Yg8TrlfJyL33v1Bq1eBrFbKv54n5RRvaYU4p0/nPaq3wi/LIapsHuGxCxEcCPureXS1UfY737dHc9DLf2bzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028777; c=relaxed/simple;
	bh=p36CvKDUqwhFVZnQfAIFI579PCDAIOYGJrMBENhQSso=;
	h=Date:To:From:Subject:Message-Id; b=CycxsqTYHvSfffk2rlYO2I9fbvJrVWqirDbK/NUrgl/lz1C/9IW2/8FbDy/XBngh2YcPC+sJ76vXoByLr6U3cNY6XsAbK63QhsvG95+3ZYWqizv+4XScLTlX04XqRelOHZ8BiiE9jgCZPzY5faiMPVkOnOFQyLfZAYgCPY+APfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2Aw8mbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2Aw8mbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151581F00898;
	Fri, 29 May 2026 04:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028776;
	bh=JzEsCDhzbhs8c2LyOWGoOaXUb0vXBHDkHZGaS2vsBPg=;
	h=Date:To:From:Subject;
	b=l2Aw8mbsmfd/GeiHt4+o8A7x6uK/S3m3WJkM/gHxA9P/ZPeMg+PhHuJ9BNEBYQYhR
	 c4JMcf5mJhn+D83nZkATUTqStnCObBJk9phaaZTLT2H/0gsXMJA2xAC9HcBf0FB6Sd
	 zsiRrRUdFtiMe6Z7agIaNknnKwP5PK1aX2RkAcLk=
Date: Thu, 28 May 2026 21:26:15 -0700
To: mm-commits@vger.kernel.org,vkoskiv@gmail.com,edumazet@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-ignore-_sdata.patch removed from -mm tree
Message-Id: <20260529042616.151581F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/bloat-o-meter: ignore _sdata
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-ignore-_sdata.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: scripts/bloat-o-meter: ignore _sdata
Date: Mon, 4 May 2026 16:36:05 -0400

_sdata is a linker symbol, but bloat-o-meter may consider it as a real
variable:

$ scripts/bloat-o-meter vmlinux.orig vmlinux
add/remove: 7/1 grow/shrink: 0/0 up/down: 3437/-4096 (-659)
Function                                     old     new   delta
crc32table_le                                  -    1024   +1024
crc32table_be                                  -    1024   +1024
crc32ctable_le                                 -    1024   +1024
byte_rev_table                                 -     256    +256
crc32_be                                       -      39     +39
crc32c                                         -      35     +35
crc32_le                                       -      35     +35
_sdata                                      4096       -   -4096
Total: Before=8592564398, After=8592563739, chg -0.00%

With the patch:

$ scripts/bloat-o-meter vmlinux.orig vmlinux
add/remove: 7/0 grow/shrink: 0/0 up/down: 3437/0 (3437)
Function                                     old     new   delta
crc32table_le                                  -    1024   +1024
crc32table_be                                  -    1024   +1024
crc32ctable_le                                 -    1024   +1024
byte_rev_table                                 -     256    +256
crc32_be                                       -      39     +39
crc32c                                         -      35     +35
crc32_le                                       -      35     +35
Total: Before=8592560302, After=8592563739, chg +0.00%

Link: https://lore.kernel.org/20260504203606.427972-1-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Cc: Valtteri Koskivuori <vkoskiv@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-ignore-_sdata
+++ a/scripts/bloat-o-meter
@@ -43,6 +43,7 @@ def getsizes(file, format):
                 if name.startswith("__se_compat_sys"): continue
                 if name.startswith("__addressable_"): continue
                 if name.startswith("__noinstr_text_start"): continue
+                if name.startswith("_sdata"): continue
                 if name == "linux_banner": continue
                 if name == "vermagic": continue
                 # statics and some other optimizations adds random .NUMBER
_

Patches currently in -mm which might be from ynorov@nvidia.com are


