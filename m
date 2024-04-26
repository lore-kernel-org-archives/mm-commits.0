Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4377CF16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103933; cv=none; b=uFSvCHr2U1qRTrW8hVPxV0Vv6B6H2YvB3PBDWfwtHNQtSBCzTZ9SnDbFzjikXn0udwuHzQj7kKL2EDYottQGhKH0FjSNMaimNE+2CjWNahkztsB0GdDXvmVYOlk7mz7ZWgwVD5vGV2zNBez/nPapAe3q0ugYIQdgyZ6HIuTUano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103933; c=relaxed/simple;
	bh=R6cYJdlm3V5kQWFKPwh5/NOP6+HYVttGuKwSPq7Uphg=;
	h=Date:To:From:Subject:Message-Id; b=Ytsj+hXUy18XMXk/ZE5gmow8LBN5wPzKsm72QU4J0gRcdnAgtSoHpTz3PQSVAl+0lzQ+D2CT2pPUd5itPZE3gESZqipl4NZsINAECvI/eKHxzUGWc28oH4VNioPUbegjvCipfkpcP+NJc5N6LanzERZWU8netmn8kZKrXzv+/gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAN7HOpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAN7HOpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62D9C116B1;
	Fri, 26 Apr 2024 03:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103933;
	bh=R6cYJdlm3V5kQWFKPwh5/NOP6+HYVttGuKwSPq7Uphg=;
	h=Date:To:From:Subject:From;
	b=BAN7HOpP1JEehvchyeCrHdexrTTvNXYRUH7aZBjrEwKlWAnlwCbS+5Ybhvus+UlFG
	 MM6K388qyHwnrsqlBepONe0G48QI94ztXybgU00XNAfJ0t6y0wzgf7siAT1cruD0va
	 wTHo+915eO9hmnp3Hrwkln7BWxKuNm/JfO3U0wGM=
Date: Thu, 25 Apr 2024 20:58:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch removed from -mm tree
Message-Id: <20240426035852.E62D9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
has been removed from the -mm tree.  Its filename was
     alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
Date: Thu, 25 Apr 2024 13:08:50 -0700

The /proc/allocinfo file exposes a tremendous about of information about
kernel build details, memory allocations (obviously), and potentially even
image layout (due to ordering).  As this is intended to be consumed by
system owners (like /proc/slabinfo), use the same file permissions as
there: 0400.

Link: https://lkml.kernel.org/r/20240425200844.work.184-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-tighten-file-permissions-on-proc-allocinfo
+++ a/lib/alloc_tag.c
@@ -129,7 +129,7 @@ size_t alloc_tag_top_users(struct codeta
 
 static void __init procfs_init(void)
 {
-	proc_create_seq("allocinfo", 0444, NULL, &allocinfo_seq_op);
+	proc_create_seq("allocinfo", 0400, NULL, &allocinfo_seq_op);
 }
 
 static bool alloc_tag_module_unload(struct codetag_type *cttype,
_

Patches currently in -mm which might be from keescook@chromium.org are


