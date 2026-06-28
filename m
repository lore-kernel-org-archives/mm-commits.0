Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CA533F599
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 20:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782677230; cv=none; b=N+j3DclEpiKr0UouEULrQ8bxq6YAwNpf6+4koAW6mVgh+2Ezs0B/dqEtyIFHqxDhPtMY/bnbJtqqJ1RfYKEQFFVSA313woaZaD/5+afBoDBbheD81oUizlFkYgv+eeCRk6ZibLh941n7G77G91mDGSLB+PV0TK+YI3E/9AloUuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782677230; c=relaxed/simple;
	bh=6zOGGeUK8Xd95VrPDHJL3Fn8QUHp3I4o5KILFADOjQg=;
	h=Date:To:From:Subject:Message-Id; b=tPI0IR73Fbjdz+I+s/KHobUsOEcTdZRQXNKIj8Lk7sV1ImMKtb9pDCxTzNkBWnJoISDqx1kXmREm52z59ryhpsDspb6VsgrNjKvIUistoNvq1xrtygmKL26wbhB2zWWw6HRU4C1pVrrqmi1l2gRS5L3NbZLmWkjLdK9LeFSWPvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGddqO6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGddqO6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740631F000E9;
	Sun, 28 Jun 2026 20:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782677228;
	bh=1BrJfb4oyuxdyd7i2S/mJMFRknVNWsjkcNRqDmRNAMM=;
	h=Date:To:From:Subject;
	b=GGddqO6wlTliuYOBV2MrqZG3B5gGmE3Qz0uiOSi9qNcZqbFFF+j1P53RhD+UPRY7P
	 iqk4fspn5US3oWaYPK8UcmfARbGekk+bpvTUtWOP5UFqh4Kb+9AYNYs/qRRqztfdKj
	 eOdz2jqEgwJA7rE3E7dEfY3JNgSceMx4cQTaoH8g=
Date: Sun, 28 Jun 2026 13:07:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,david@kernel.org,imran.f.khan@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch added to mm-new branch
Message-Id: <20260628200708.740631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
Date: Thu, 4 Jun 2026 21:42:45 +0800

frag_show_print() just reads zone->free_area[order].nr_free, so it can
safely do this without needing the zone->lock.

Pass nolock=true from frag_show(), so that walk_zones_in_node() can skip
the zone->lock acquisition.

Link: https://lore.kernel.org/20260604134245.1580287-1-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads
+++ a/mm/vmstat.c
@@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_f
 static int frag_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
+	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
 	return 0;
 }
 
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are

mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch

