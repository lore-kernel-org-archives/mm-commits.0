Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C2287276
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 02:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086671; cv=none; b=s5c5zHvjKObw+DdMsTjKuomAUiwoJfkYF8sW6+x7i81ACdM9dIUKG0hR+TfQBbHnLLjxx+P5yrof3vrSEG5t9p0HFGboz4+OHg02Sn4C9jGIJItjoU8Gnm5WKhqPD0VkQugWBjCBaEx0gb+SBbLvZB1K+w0Nhg9kYHOW2soTkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086671; c=relaxed/simple;
	bh=UOUVblr41LvCQGpYY+XuTsqOx6zdiKTDhItU0JdydaM=;
	h=Date:To:From:Subject:Message-Id; b=KLIQolCJg1+3ftgIR1e/5bxIoOK/vRZ5O44TbwgQcaZbeZs8uv9GrumxCQSC7DneuS4/fRwnJ3pOWgz6DYDujMq434HGmDh4a7F+EhW3t0dHMw99ikKWGykFntI29JvSfRdpddQ6aQwaOOvoH+D2lillofFTdlI3Kz1M7zDNBoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zy2n/moH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zy2n/moH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83098C116C6;
	Tue,  3 Feb 2026 02:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086671;
	bh=UOUVblr41LvCQGpYY+XuTsqOx6zdiKTDhItU0JdydaM=;
	h=Date:To:From:Subject:From;
	b=Zy2n/moH/0nQ68lzuEnuaXqZZ7yDZky/zhiNqjVo3ZpdXAVh+BaSFP+HPfufJgDc3
	 SMrk8jnpySfI5vsSAYziAzj0tI9dNlJ/qsKl83Pjd5WB8Vb9eSA6lTb8uevXms+hNk
	 pCfsi69WIa9ZzdXklvquuGNqc9DwVR6Q0D0ghjUk=
Date: Mon, 02 Feb 2026 18:44:30 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch removed from -mm tree
Message-Id: <20260203024431.83098C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: luo_file: do not clear serialized_data on unfreeze
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: liveupdate: luo_file: do not clear serialized_data on unfreeze
Date: Tue, 27 Jan 2026 00:02:52 +0100

Patch series "liveupdate: fixes in error handling".

This series contains some fixes in LUO's error handling paths.

The first patch deals with failed freeze() attempts.  The cleanup path
calls unfreeze, and that clears some data needed by later unpreserve
calls.

The second patch is a bit more involved.  It deals with failed retrieve()
attempts.  To do so properly, it reworks some of the error handling logic
in luo_file core.

Both these fixes are "theoretical" -- in the sense that I have not been
able to reproduce either of them in normal operation.  The only supported
file type right now is memfd, and there is nothing userspace can do right
now to make it fail its retrieve or freeze.  I need to make the retrieve
or freeze fail by artificially injecting errors.  The injected errors
trigger a use-after-free and a double-free.

That said, once more complex file handlers are added or memfd preservation
is used in ways not currently expected or covered by the tests, we will be
able to see them on real systems.


This patch (of 2):

The unfreeze operation is supposed to undo the effects of the freeze
operation.  serialized_data is not set by freeze, but by preserve. 
Consequently, the unpreserve operation needs to access serialized_data to
undo the effects of the preserve operation.  This includes freeing the
serialized data structures for example.

If a freeze callback fails, unfreeze is called for all frozen files.  This
would clear serialized_data for them.  Since live update has failed, it
can be expected that userspace aborts, releasing all sessions.  When the
sessions are released, unpreserve will be called for all files.  The
unfrozen files will see 0 in their serialized_data.  This is not expected
by file handlers, and they might either fail, leaking data and state, or
might even crash or cause invalid memory access.

Do not clear serialized_data on unfreeze so it gets passed on to
unpreserve.  There is no need to clear it on unpreserve since luo_file
will be freed immediately after.

Link: https://lkml.kernel.org/r/20260126230302.2936817-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260126230302.2936817-2-pratyush@kernel.org
Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze
+++ a/kernel/liveupdate/luo_file.c
@@ -402,8 +402,6 @@ static void luo_file_unfreeze_one(struct
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-
-	luo_file->serialized_data = 0;
 }
 
 static void __luo_file_unfreeze(struct luo_file_set *file_set,
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
liveupdate-luo_file-remember-retrieve-status.patch

