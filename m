Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546BD101C8;
	Tue,  8 Oct 2024 01:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728350166; cv=none; b=ChT4HGgZAA8KOQSEv0cFNgWdw2g68KwojfnPrcJwoViTmh7bZyURDe/2YAqzn5A6xbfTK8Ck3zV6pk38KX6Lkc/ra0mTOCUtqTd2VxH9RM26iiqDNBG/2QfFmLOUDoigZ270D0GKbiHLE5XN3H8lqjpnXOXhoKjzubZjiE7Q6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728350166; c=relaxed/simple;
	bh=WcG8SsgyprgukliU7UGp1ZoWz6SwT+7Bf1sJFZ2FIbg=;
	h=Date:To:From:Subject:Message-Id; b=knfkIUiasYFYQhjRxUSt1OGrMbZh9VFZupRXIV7rrZ99E7x5oDYUHpe6/ALbCdG80Tq1uCMuP3Fok1p2Xgg3LxALESFbIyssXrJvOFHXCk8zhMKx9roJ5dSEpIeGWpdiqj8kHL0zkmDtWOkZPWcuvqtwBOI9WJK5l9rbyUrCrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G43W1zKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G43W1zKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2BAC4CECF;
	Tue,  8 Oct 2024 01:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728350165;
	bh=WcG8SsgyprgukliU7UGp1ZoWz6SwT+7Bf1sJFZ2FIbg=;
	h=Date:To:From:Subject:From;
	b=G43W1zKo2HkwXLLb7L1Y0+FEp8qF+Z8nUPwqBcoFZHa7KQ8CIm4wOiIfmfvop/yI4
	 NIerCiqTYZZ33xhh+zY3HlGabhy59eWGDk10vxgxsr/3y8nlIjtAmVFftnSXkBefrF
	 tBwW5nsyi8Pukx/5WXzrQCuSm1PfkyyYjARLZZI0=
Date: Mon, 07 Oct 2024 18:16:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,stable@vger.kernel.org,kent.overstreet@linux.dev,greearb@candelatech.com,fw@strlen.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008011605.BC2BAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch

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
From: Florian Westphal <fw@strlen.de>
Subject: lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
Date: Mon, 7 Oct 2024 22:52:24 +0200

Ben Greear reports following splat:
 ------------[ cut here ]------------
 net/netfilter/nf_nat_core.c:1114 module nf_nat func:nf_nat_register_fn has 256 allocated at module unload
 WARNING: CPU: 1 PID: 10421 at lib/alloc_tag.c:168 alloc_tag_module_unload+0x22b/0x3f0
 Modules linked in: nf_nat(-) btrfs ufs qnx4 hfsplus hfs minix vfat msdos fat
...
 Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
 RIP: 0010:alloc_tag_module_unload+0x22b/0x3f0
  codetag_unload_module+0x19b/0x2a0
  ? codetag_load_module+0x80/0x80

nf_nat module exit calls kfree_rcu on those addresses, but the free
operation is likely still pending by the time alloc_tag checks for leaks.

Wait for outstanding kfree_rcu operations to complete before checking
resolves this warning.

Reproducer:
unshare -n iptables-nft -t nat -A PREROUTING -p tcp
grep nf_nat /proc/allocinfo # will list 4 allocations
rmmod nft_chain_nat
rmmod nf_nat                # will WARN.

Link: https://lkml.kernel.org/r/20241007205236.11847-1-fw@strlen.de
Fixes: a473573964e5 ("lib: code tagging module support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Closes: https://lore.kernel.org/netdev/bdaaef9d-4364-4171-b82b-bcfc12e207eb@candelatech.com/
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/codetag.c~lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls
+++ a/lib/codetag.c
@@ -228,6 +228,8 @@ bool codetag_unload_module(struct module
 	if (!mod)
 		return true;
 
+	kvfree_rcu_barrier();
+
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {
 		struct codetag_module *found = NULL;
_

Patches currently in -mm which might be from fw@strlen.de are

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch

