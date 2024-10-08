Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7F31862A
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728350168; cv=none; b=V8RLCNJcPEAAR89dYzqHd1XZzyi4CewLJV6yCRLCJGusxmB9KEwgLFgCnuJQnR5bMjjv60QvMr2y72X7tUs7LK3NXEi7IPana2z0pIseezo6//FWhq4qH98RAf8mxD/PhvD2/789/19+oze25VNySuZmGcwDw3vQrl9z5pm71Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728350168; c=relaxed/simple;
	bh=7ZkuDI9dIE4Zog+0/vDzQfBA+g7duB1Tw21AL9bBaZE=;
	h=Date:To:From:Subject:Message-Id; b=tPbI0pNSsabdD0khFtsH0TxOUFBsWXYCKIlvbgoWdLTXP3NmntHNXyFto5VFtBYSePrb03jA9U1F4p7lyIZ8487RVSURTexVp8Y8I655q+SlsXRAPx/K42iZYi2uHj4UcN+EclqcEhXkHKG0jgKGSImyhyL2tjIF/qZiVATSP5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmJi69uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmJi69uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4E1C4CECD;
	Tue,  8 Oct 2024 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728350167;
	bh=7ZkuDI9dIE4Zog+0/vDzQfBA+g7duB1Tw21AL9bBaZE=;
	h=Date:To:From:Subject:From;
	b=bmJi69uPmjMhKp0tSXNXUUnhBHfh+ABjY6qKbn5/z7sXTUmJ6wetR/uXyB654Ttw7
	 qa330FDGJ3N8WBc3KQ8hLVllS4yBXQUiTc+SoORXG+59/Rv+3tyCMNjjdXeCyRjnoa
	 Mv9bh9X11qIT+mvoqfCLl9RW2RJaxsfdAEODb168=
Date: Mon, 07 Oct 2024 18:16:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,kent.overstreet@linux.dev,greearb@candelatech.com,fw@strlen.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008011607.9E4E1C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
Date: Mon Oct  7 06:06:19 PM PDT 2024

Cc: Ben Greear <greearb@candelatech.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/codetag.c~lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
+++ a/lib/codetag.c
@@ -228,6 +228,7 @@ bool codetag_unload_module(struct module
 	if (!mod)
 		return true;
 
+	/* await any module's kfree_rcu() operations to complete */
 	kvfree_rcu_barrier();
 
 	mutex_lock(&codetag_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch

