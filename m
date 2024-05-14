Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C29180A9C
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715718016; cv=none; b=sF7tAqjzDmra+6znBX7ezAMj1Dbg0fBd9RdnpQAwk7RiAI6q6l/Ah0knrGPcltxG4Nqko2LV7QDZPP3Csom+eZj1DAaDMVjvQF9ZMKmk5uJfd1KPiykPA64lbM4opSf4uW0Ovc9aso2eZcifY615+oCTl5W07D1G7COBxBJt3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715718016; c=relaxed/simple;
	bh=0a9a9wEU7G3YGsySq18zF5XfDaXeQF0782pXTPsPyPo=;
	h=Date:To:From:Subject:Message-Id; b=USutObUl8sTqLTadU/myJsTJoH5uj7rThK2hQEV/3fn6u+zfqBuuRSmac5LACe0kiKl4Jb8TQ3eQdW4krIl0ZdCPDaURoQ9byKqpyM7IHDKgyt0F3K/WCVz88Rz8yGy/YjA0GZeIb9m8mAsgDsrmaP6hDkr9V8HUqLcXER9i+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTQxYvFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTQxYvFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7D4C2BD10;
	Tue, 14 May 2024 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715718016;
	bh=0a9a9wEU7G3YGsySq18zF5XfDaXeQF0782pXTPsPyPo=;
	h=Date:To:From:Subject:From;
	b=qTQxYvFplYkl2JoU6XgA05uDVQgLVYECx8H0pNiEcgEUbP9qIZU4C3mSySBkPALgm
	 gMpipcagpDJr+YrBIgmpya5J+J7wKw8KaNsqXBCra64xxNMKdLS184STzdYZD2kchD
	 9gKpK6c64lChJFoqo87ZHDOELExFrMY/YRzmacXk=
Date: Tue, 14 May 2024 13:20:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-version-into-proc-allocinfo-output-fix.patch added to mm-unstable branch
Message-Id: <20240514202016.2B7D4C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-add-version-into-proc-allocinfo-output-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-version-into-proc-allocinfo-output-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-version-into-proc-allocinfo-output-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-add-version-into-proc-allocinfo-output-fix
Date: Tue May 14 01:19:12 PM PDT 2024

remove stray newline from struct allocinfo_private

Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/alloc_tag.c~lib-add-version-into-proc-allocinfo-output-fix
+++ a/lib/alloc_tag.c
@@ -19,7 +19,6 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
-
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-add-version-into-proc-allocinfo-output-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

