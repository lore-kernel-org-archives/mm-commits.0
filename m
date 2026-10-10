Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC47372B45
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791669667; cv=none; b=nMbww6YShQNnw2+EpGMtUAA3lwAqHgITBqRm9dRiWvOtpwJIau6jNw1+nplGv8K9i1p4frgSXYlFEBxYbwZWCCdjaZXRwMCwRzyqiiXC0qRO8r9cye6krQvbF8BPBQwkzyLwg0rzVNVIqtVB36LM2Md4T8Y4QJdMLNWCXLsmWNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791669667; c=relaxed/simple;
	bh=ku6+IJl/X2TR+I/LiQeYmZCWxZOnRJrbhl5feFypvGQ=;
	h=Date:To:From:Subject:Message-Id; b=ZZyf5Tae99SiMZ2fBT5gocBNx3w29GSec4aeQE6WVHVeqQGRKkxzbvTDit/mMqj9knaw6kN6oN4rFS/cyTZbqTKl/n9GnqHicYRiP4u1970LV0xTOwC4x1lol/lPaWOXtKTDgcA/RuxlDcUP/5KGNKn383Ve7uxo6YKyewDziXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtSdvrCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtSdvrCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739421F00893;
	Sat, 10 Oct 2026 22:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791669653;
	bh=uHKoMK5P0dEh777ipweTCgI+JLmuuDcLwXygx0TcKxI=;
	h=Date:To:From:Subject;
	b=rtSdvrCCNlAf0dMNINpMNQs7fK9MNBZ3qaBLZDtj9Wys+xvDBzhA+Gwy2rgH+qtYa
	 PkJCmjNiPf/eqHUMhnKtjXV1oCCbbVJndRtELiP0MobbgQezbtCvgnXwHToGfZYnwZ
	 Iwj5Q0JYGiVxy/TjY1Vd5r+xzJy0wPc+PlfHRarg=
Date: Sat, 10 Oct 2026 15:00:53 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + a.patch added to mm-unstable branch
Message-Id: <20261010220053.739421F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: a
has been added to the -mm mm-unstable branch.  Its filename is
     a.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/a.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a
Date: Sat Oct 10 02:38:48 PM PDT 2026
Subject: mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
Date: Sat, 03 Oct 2026 17:32:32 +0100

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping. If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is guaranteed
to drop the refcount for the original file the mapping was made under, but
this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get, which
is rather poorly named and unfortunately fails to correctly track whether
or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
map_put_vm_file().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to map_put_vm_file().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call
map_put_vm_file() in this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does not
need to be a fix.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: introduce and use vma_[flags_]can_merge()
Date: Sat, 03 Oct 2026 17:32:33 +0100

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-2-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: consistently validate VMA state after mmap[_prepare] hooks
Date: Sat, 03 Oct 2026 17:32:34 +0100

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

Also extend the vm_start check to vm_end also - drivers must not change the
VMA range at all.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
Date: Wed,  7 Oct 2026 21:47:08 +0200

Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
after unmap_region(), so free_pgtables() unlinks the never-linked VMA
and drops i_mmap_writable. Once it goes negative, every later shared
writable mmap of that file fails with -EPERM until reboot.

Clear vm_file across unmap_region() only, so that free_pgtables() does
not unlink a VMA that was never linked to the file, and restore it for
vma_close(): when the hook succeeded and the validation failed, the
driver's close() still runs and may use vma->vm_file.

Link: https://lore.kernel.org/20261007194708.2009-1-okerixx@gmail.com
Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Tested-by: Bert Karwatzki <spasswolf@web.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Subject: mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
Date: Sat, 03 Oct 2026 17:32:35 +0100

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data.

However, if the VMA is mergeable, it might then mistakenly be merged with
another VMA without having populated the range.

Every mmap action currently available sets VMA flags such that the VMA
cannot be merged.

However, to ensure that no future mmap action falls foul of this, assert
that this is the case upon mmap_prepare validation.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-4-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: make map_kernel_pages_[prepare,complete] internal and unexported
Date: Sat, 03 Oct 2026 17:32:36 +0100

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-5-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: tidy up map kernel pages enum values
Date: Sat, 03 Oct 2026 17:32:37 +0100

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-6-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: add mmap action for discontiguous kernel page mapping
Date: Sat, 03 Oct 2026 17:32:38 +0100

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Also update the compatibility layer to do this too via
compat_mmap_action_abort().

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page.
* discontig_kernel_map_page_range() - Maps a struct page ** array of a
  specified count, mapping only those pages which fit in the VMA.

The userland VMA tests are updated accordingly.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: docs: filesystems: update mmap_prepare docs for discontig kernel pgs
Date: Sat, 03 Oct 2026 17:32:39 +0100

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: drivers/usb/mon: update to use mmap_prepare + map kernel pages
Date: Sat, 03 Oct 2026 17:32:40 +0100

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: infiniband: update hfi1 to use remap_vmalloc_range()
Date: Sat, 03 Oct 2026 17:32:41 +0100

In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniband
drivers currently installs a fault handler, and then smuggles the kernel
virtual address of this range in vma->vm_pgoff.

This is exposing KASLR-sensitive internal kernel state in the VMA, and is
entirely unnecessary.

Instead, use remap_vmalloc_range() to remap the VMA to the span, and
eliminate the fault handler altogether.

remap_vmalloc_range() checks that the VMA does not extend beyond the
vmalloc area, and the driver already requires the VMA to exactly match the
span of the memory being mapped, so this has no impact.

The memory is all preallocated so not having a fault handler has no impact
either, other than pre-mapping the ranges which is beneficial.

We also remove the VM_IO flag as it's not appropriate here, and the
VM_DONTEXPAND flag as remap_vmalloc_range() will set it (and also mark the
range correctly as a mixed map).

We also update the vmalloc paths to place the virtual kernel address in
memvirt, rather than overloading the physical address memaddr. We predicate
the vmalloc handling on the vmalloc flag before we check memvirt for the
virtual address-derived PFN remap path, so this works fine.

remap_vmalloc_range() requires that the vmalloc()'d areas were all
allocated using vmalloc_user() - each of cq->comps,
uctxt->subctxt_rcvegrbuf, uctxt->subctxt_rcvhdr_base,
uctxt->subctxt_uregbase and dd->events were allocated this way, so that
requirement is satisfied.

We also remove VM_IO and VM_DONTEXPAND from the STATUS command, as these
are both set on remap.

Finally, we remove VM_DONTEXPAND from the PIO_BUFS, PIO_BUFS_SOP and UREGS
commands, as these are also all set on remap. PIO_CRED retains it, as
dma_mmap_coherent() may map via vm_insert_page() on the IOMMU-DMA path,
which sets only VM_MIXEDMAP. The RCV_HDRQ, RCV_EGRBUF and RTAIL commands
also map via dma_mmap_coherent() and never set VM_DONTEXPAND, so set it for
them for the same reason.

Note that we retain expected behaviour throughout - the vmalloc remapped
ranges set VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND for each range.

VM_IO was never appropriate as the ranges are explicitly not MMIO, and the
reference to the v3.7 VM_RESERVED semantics map on to VM_MIXEDMAP |
VM_DONTDUMP | VM_DONTEXPAND correctly - no core dump, unmergeable, no
normal vm page for purposes of reclaim/migration/etc.

There is a change in behaviour in that pages mapped using
remap_vmalloc_range() will now have normal GUP-able pages, however this
should have no impact as there is no reason not to allow this.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-10-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: selinux: reject writable opens of policy file, drop mmap shared/write check
Date: Sat, 03 Oct 2026 17:32:42 +0100

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: ALSA: pcm: use vm_insert_page() to map PCM status page
Date: Sat, 03 Oct 2026 17:32:43 +0100

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must not be mm-managed; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
Date: Sat, 03 Oct 2026 17:32:44 +0100

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: add vma[_flags]_is_mm_managed() predicates
Date: Sat, 03 Oct 2026 17:32:45 +0100

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
VMA_MIXEDMAP_BIT flags means, and then refer to that function for
determining VMA mergeability.

If neither of these flags are set, that means the contents of the mapping
are managed by core mm.

Otherwise they are instead owned by some other kernel component, usually a
driver: the memory may be MMIO, kernel-allocated pages or even ordinary
pages the driver maps itself, but core mm must not populate, reclaim,
migrate, copy-on-write or merge the range itself.

We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
on ordinary VMAs while locking them, which is addressed later in this
series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
Date: Sat, 03 Oct 2026 17:32:46 +0100

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, forbid this for mm-managed mappings as
identified by vma_flags_is_mm_managed().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a mapping which is not
mm-managed,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
mapping, no functional change is intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-15-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: add and use vma_[flags]_is_fixed_mapping
Date: Sat, 03 Oct 2026 17:32:47 +0100

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to mappings not managed by core mm, however
VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: scsi: sg: convert mmap hook to mmap_prepare and rework
Date: Sat, 03 Oct 2026 17:32:48 +0100

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
Date: Sat, 03 Oct 2026 17:32:49 +0100

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
Date: Sat, 03 Oct 2026 17:32:50 +0100

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
Date: Sat, 03 Oct 2026 17:32:51 +0100

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
Date: Sat, 03 Oct 2026 17:32:52 +0100

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/mlock: clear VMA_LOCKED_MASK over mmap callback
Date: Sat, 03 Oct 2026 17:32:53 +0100

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-22-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
Date: Sat, 03 Oct 2026 17:32:54 +0100

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

With the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.

The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

Additionally, in order to ensure a racing unmap/migration releases the
reference munlock_folio() took (whose put was batched), check
VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
and try_to_migrate_one().

While here, also replace some deprecated VMA flag predicates.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-23-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
Date: Sat, 03 Oct 2026 17:32:55 +0100

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as not being mm-managed. The check WARNs and
fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
without a kernel mapping.

No functional change intended for in-tree code.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-24-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
Date: Sat, 03 Oct 2026 17:32:56 +0100

We have now made it such that every driver which sets VMA_IO_BIT marks it
as not mm-managed.

However, vma_flags_is_mm_managed() currently treats VMA_IO_BIT as
disqualifying. This was a product of drivers previously marking a range as
not mm-managed by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_mm_managed(),
and update mmap_validate_vma_flags() to use vma_flags_is_mm_managed()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_mm_managed().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps mappings which are not mm-managed, as
drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to mappings not managed
by core mm, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
mappings not managed by core mm - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-25-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: remove hugetlb_inline.h
Date: Sat, 03 Oct 2026 17:32:57 +0100

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-26-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
Date: Sat, 03 Oct 2026 17:32:58 +0100

The is_vm_hugetlb_page() predicate is badly named - the mapping can span
more than a page and it is inconsistent with other VMA predicates that
typically are prefixed by vma_.

Rename to vma_is_hugetlb() for consistency, and while we're here update
some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
oopses.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-27-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Anup Patel <anup@brainfault.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: drop some redundant checks around hugetlb VMAs
Date: Sat, 03 Oct 2026 17:32:59 +0100

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-28-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
Date: Sat, 03 Oct 2026 17:33:00 +0100

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-29-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/vma: introduce vma[_flags]_is_mm_backed()
Date: Sat, 03 Oct 2026 17:33:01 +0100

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler - and which core
mm has not reserved the right to discard.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Droppable mappings are excluded as core mm has promised it may discard them
at any time.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-30-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/uffd: use predicates for userfaultfd checks
Date: Sat, 03 Oct 2026 17:33:02 +0100

Rather than directly checking VMA flags, use the newly introduced
vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that mm-managed mappings may not set
VMA_IO_BIT so the check is now redundant.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-31-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/madvise: use predicates for madvise(..., MADV_DOFORK)
Date: Sat, 03 Oct 2026 17:33:03 +0100

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
and
VMA_IO_BIT.

Now the invariant is established that mm-managed mappings may not set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a fixed or non-mm-managed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-32-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
Date: Sat, 03 Oct 2026 17:33:04 +0100

It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a fixed or non-mm-managed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
mappings - excluding non-mm-managed, fixed or droppable mappings is exactly
what vma_is_mm_backed() tests for, so in these cases use this predicate.

should_skip_vma() tests for locked, fixed or non-mm-managed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-33-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
Date: Sat, 03 Oct 2026 17:33:05 +0100

A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
mm-managed mappings may not set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-34-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
Date: Sat, 03 Oct 2026 17:33:06 +0100

Now we have the expressive vma_is_mm_managed() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as mm-managed mappings may not set
it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-35-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Date: Sat, 03 Oct 2026 17:33:07 +0100

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-36-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: fuse: dax: do not set VM_MIXEDMAP
Date: Sat, 03 Oct 2026 17:33:08 +0100

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as not mm-managed, making fuse
DAX the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its check for mappings not managed by core mm explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-37-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Subject: mm/huge_memory: remove vma_is_special_huge()
Date: Sat, 03 Oct 2026 17:33:09 +0100

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for !vma_is_mm_managed() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that
mm-managed mappings may not set VMA_IO_BIT.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-38-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
---

 Documentation/filesystems/mmap_prepare.rst |   81 ++++++
 arch/arm64/kvm/mmu.c                       |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c       |    6 
 arch/powerpc/mm/nohash/e500_hugetlbpage.c  |    2 
 arch/powerpc/mm/nohash/tlb.c               |    2 
 arch/riscv/kvm/mmu.c                       |    2 
 arch/riscv/mm/tlbflush.c                   |    2 
 arch/s390/mm/gmap_helpers.c                |    6 
 arch/sparc/mm/init_64.c                    |    2 
 arch/x86/kernel/uprobes.c                  |    2 
 drivers/gpu/drm/drm_gpusvm.c               |    5 
 drivers/hsi/clients/cmt_speech.c           |   33 --
 drivers/infiniband/hw/hfi1/file_ops.c      |   83 +-----
 drivers/scsi/sg.c                          |  115 +++-----
 drivers/usb/mon/mon_bin.c                  |   82 ++++--
 drivers/video/fbdev/core/fb_defio.c        |    6 
 drivers/video/fbdev/ssd1307fb.c            |    2 
 fs/coredump.c                              |    2 
 fs/fuse/dax.c                              |    2 
 fs/hugetlbfs/inode.c                       |    2 
 fs/proc/task_mmu.c                         |    8 
 include/asm-generic/tlb.h                  |    4 
 include/linux/hugetlb.h                    |    5 
 include/linux/hugetlb_inline.h             |   28 --
 include/linux/mm.h                         |  240 +++++++++++++++++-
 include/linux/mm_types.h                   |   50 +++
 include/linux/pagemap.h                    |    1 
 include/linux/rmap.h                       |    2 
 include/linux/userfaultfd_k.h              |    1 
 kernel/bpf/arena.c                         |    3 
 kernel/events/core.c                       |    2 
 kernel/events/uprobes.c                    |    4 
 kernel/sched/fair.c                        |    3 
 mm/folio.c                                 |    2 
 mm/gup.c                                   |    8 
 mm/huge_memory.c                           |   31 --
 mm/hugetlb.c                               |   14 -
 mm/internal.h                              |   80 +++---
 mm/ksm.c                                   |    4 
 mm/madvise.c                               |   28 +-
 mm/memory.c                                |  129 ++++++++-
 mm/mempolicy.c                             |    2 
 mm/migrate_device.c                        |   12 
 mm/mlock.c                                 |   51 +--
 mm/mmap.c                                  |    2 
 mm/mmu_gather.c                            |    2 
 mm/mprotect.c                              |    5 
 mm/mremap.c                                |   11 
 mm/page_vma_mapped.c                       |    4 
 mm/pagewalk.c                              |    2 
 mm/rmap.c                                  |    8 
 mm/swapfile.c                              |    2 
 mm/userfaultfd.c                           |   43 +--
 mm/util.c                                  |   49 ++-
 mm/vma.c                                   |  248 ++++++++++++++-----
 mm/vma.h                                   |   31 +-
 mm/vma_internal.h                          |    1 
 mm/vmscan.c                                |    9 
 security/selinux/selinuxfs.c               |   11 
 sound/core/pcm_native.c                    |   38 --
 tools/testing/vma/include/dup.h            |   80 +++++-
 tools/testing/vma/include/stubs.h          |    2 
 tools/testing/vma/tests/merge.c            |   10 
 63 files changed, 1149 insertions(+), 560 deletions(-)

--- a/arch/arm64/kvm/mmu.c~a
+++ a/arch/arm64/kvm/mmu.c
@@ -1470,7 +1470,7 @@ transparent_hugepage_adjust(struct kvm *
 
 static int get_vma_page_shift(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	return PAGE_SHIFT;
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~a
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -627,7 +627,7 @@ void radix__local_flush_tlb_page(struct
 {
 #ifdef CONFIG_HUGETLB_PAGE
 	/* need the return fix for nohash.c */
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return radix__local_flush_hugetlb_page(vma, vmaddr);
 #endif
 	radix__local_flush_tlb_page_psize(vma->vm_mm, vmaddr, mmu_virtual_psize);
@@ -945,7 +945,7 @@ void radix__flush_tlb_page_psize(struct
 void radix__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return radix__flush_hugetlb_page(vma, vmaddr);
 #endif
 	radix__flush_tlb_page_psize(vma->vm_mm, vmaddr, mmu_virtual_psize);
@@ -1113,7 +1113,7 @@ void radix__flush_tlb_range(struct vm_ar
 
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return radix__flush_hugetlb_tlb_range(vma, start, end);
 #endif
 
--- a/arch/powerpc/mm/nohash/e500_hugetlbpage.c~a
+++ a/arch/powerpc/mm/nohash/e500_hugetlbpage.c
@@ -180,7 +180,7 @@ book3e_hugetlb_preload(struct vm_area_st
  */
 void __update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		book3e_hugetlb_preload(vma, address, *ptep);
 }
 
--- a/arch/powerpc/mm/nohash/tlb.c~a
+++ a/arch/powerpc/mm/nohash/tlb.c
@@ -278,7 +278,7 @@ void __flush_tlb_page(struct mm_struct *
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	if (vma && is_vm_hugetlb_page(vma))
+	if (vma && vma_is_hugetlb(vma))
 		flush_hugetlb_page(vma, vmaddr);
 #endif
 
--- a/arch/riscv/kvm/mmu.c~a
+++ a/arch/riscv/kvm/mmu.c
@@ -665,7 +665,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 		return -EFAULT;
 	}
 
-	is_hugetlb = is_vm_hugetlb_page(vma);
+	is_hugetlb = vma_is_hugetlb(vma);
 	if (is_hugetlb)
 		vma_pageshift = huge_page_shift(hstate_vma(vma));
 	else
--- a/arch/riscv/mm/tlbflush.c~a
+++ a/arch/riscv/mm/tlbflush.c
@@ -149,7 +149,7 @@ void flush_tlb_range(struct vm_area_stru
 {
 	unsigned long stride_size;
 
-	if (!is_vm_hugetlb_page(vma)) {
+	if (!vma_is_hugetlb(vma)) {
 		stride_size = PAGE_SIZE;
 	} else {
 		stride_size = huge_page_size(hstate_vma(vma));
--- a/arch/s390/mm/gmap_helpers.c~a
+++ a/arch/s390/mm/gmap_helpers.c
@@ -102,7 +102,7 @@ __context_unsafe(/* pte_unmap_unlock() n
 
 	/* Find the vm address for the guest address */
 	vma = vma_lookup(mm, vmaddr);
-	if (!vma || is_vm_hugetlb_page(vma))
+	if (!vma || vma_is_hugetlb(vma))
 		return;
 
 	/* Get pointer to the page table entry */
@@ -139,7 +139,7 @@ void gmap_helper_discard(struct mm_struc
 		vma = find_vma_intersection(mm, vmaddr, end);
 		if (!vma)
 			return;
-		if (!is_vm_hugetlb_page(vma))
+		if (!vma_is_hugetlb(vma))
 			zap_vma_range(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
 		vmaddr = vma->vm_end;
 	}
@@ -247,7 +247,7 @@ static int __gmap_helper_unshare_zeropag
 		 * proof to catch unexpected zeropages in other mappings and
 		 * fail.
 		 */
-		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
+		if ((vma->vm_flags & VM_PFNMAP) || vma_is_hugetlb(vma))
 			continue;
 		addr = vma->vm_start;
 
--- a/arch/sparc/mm/init_64.c~a
+++ a/arch/sparc/mm/init_64.c
@@ -413,7 +413,7 @@ void update_mmu_cache_range(struct vm_fa
 	if (mm->context.hugetlb_pte_count || mm->context.thp_pte_count) {
 		unsigned long hugepage_size = PAGE_SIZE;
 
-		if (is_vm_hugetlb_page(vma))
+		if (vma_is_hugetlb(vma))
 			hugepage_size = huge_page_size(hstate_vma(vma));
 
 		if (hugepage_size >= PUD_SIZE) {
--- a/arch/x86/kernel/uprobes.c~a
+++ a/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
--- a/Documentation/filesystems/mmap_prepare.rst~a
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. As with a compound page, if more pages are specified than remain in
+  the VMA then only those that fit will be mapped.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.
--- a/drivers/gpu/drm/drm_gpusvm.c~a
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct d
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !is_vm_hugetlb_page(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
--- a/drivers/hsi/clients/cmt_speech.c~a
+++ a/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_if
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *f
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_c
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,
--- a/drivers/infiniband/hw/hfi1/file_ops.c~a
+++ a/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,7 +70,6 @@ static int set_ctxt_pkey(struct hfi1_ctx
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -85,10 +84,6 @@ static const struct file_operations hfi1
 	.llseek = noop_llseek,
 };
 
-static const struct vm_operations_struct vm_ops = {
-	.fault = vma_fault,
-};
-
 /*
  * Types of memories mapped into user processes' space
  */
@@ -304,13 +299,13 @@ static ssize_t hfi1_write_iter(struct ki
 	return reqs;
 }
 
-static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 vmf,
+static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 is_vmalloc,
 			     u64 memaddr, void *memvirt, dma_addr_t memdma,
 			     ssize_t memlen, struct vm_area_struct *vma)
 {
 	hfi1_cdbg(PROC,
-		  "%u:%u type:%u io/vf/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
-		  ctxt, subctxt, type, mapio, vmf, !!memdma,
+		  "%u:%u type:%u io/vmalloc/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
+		  ctxt, subctxt, type, mapio, is_vmalloc, !!memdma,
 		  memaddr ?: (u64)memvirt, memlen,
 		  vma->vm_end - vma->vm_start, vma->vm_flags);
 }
@@ -325,7 +320,7 @@ static int hfi1_file_mmap(struct file *f
 		memaddr = 0;
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
-	u8 subctxt, mapio = 0, vmf = 0, type;
+	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 	size_t memdmalen = 0;
 	ssize_t memlen = 0;
 	int ret = 0;
@@ -348,7 +343,7 @@ static int hfi1_file_mmap(struct file *f
 	/*
 	 * vm_pgoff is used as a buffer selector cookie.  Always mmap from
 	 * the beginning.
-	 */ 
+	 */
 	vma->vm_pgoff = 0;
 	flags = vma->vm_flags;
 
@@ -367,7 +362,7 @@ static int hfi1_file_mmap(struct file *f
 		 */
 		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -411,6 +406,7 @@ static int hfi1_file_mmap(struct file *f
 		memlen = rcvhdrq_size(uctxt);
 		memvirt = uctxt->rcvhdrq;
 		memdma = uctxt->rcvhdrq_dma;
+		flags |= VM_DONTEXPAND;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -432,7 +428,7 @@ static int hfi1_file_mmap(struct file *f
 			ret = -EPERM;
 			goto done;
 		}
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vm_flags_mod(vma, VM_DONTEXPAND, VM_MAYWRITE);
 		/*
 		 * Mmap multiple separate allocations into a single vma.  From
 		 * here, dma_mmap_coherent() calls dma_direct_mmap(), which
@@ -448,7 +444,7 @@ static int hfi1_file_mmap(struct file *f
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -477,7 +473,7 @@ static int hfi1_file_mmap(struct file *f
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -486,15 +482,10 @@ static int hfi1_file_mmap(struct file *f
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)
-			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
+		memvirt = dd->events + uctxt_offset(uctxt);
+		memvirt = (void *)(((uintptr_t)memvirt) & PAGE_MASK);
 		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case STATUS:
 		if (flags & VM_WRITE) {
@@ -503,7 +494,6 @@ static int hfi1_file_mmap(struct file *f
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -522,25 +512,23 @@ static int hfi1_file_mmap(struct file *f
 		memvirt = (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
 		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
+		flags |= VM_DONTEXPAND;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
+		memvirt = uctxt->subctxt_uregbase;
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
+		memvirt = uctxt->subctxt_rcvhdr_base;
 		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
+		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SDMA_COMP: {
 		struct hfi1_user_sdma_comp_q *cq = fd->cq;
@@ -549,10 +537,9 @@ static int hfi1_file_mmap(struct file *f
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
+		memvirt = cq->comps;
 		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	}
 	default:
@@ -569,12 +556,10 @@ static int hfi1_file_mmap(struct file *f
 	}
 
 	vm_flags_reset(vma, flags);
-	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
 		  memlen, vma);
-	if (vmf) {
-		vma->vm_pgoff = PFN_DOWN(memaddr);
-		vma->vm_ops = &vm_ops;
-		ret = 0;
+	if (is_vmalloc) {
+		ret = remap_vmalloc_range(vma, memvirt, 0);
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 					memvirt, memdma,
@@ -599,24 +584,6 @@ done:
 	return ret;
 }
 
-/*
- * Local (non-chip) user memory is not mapped right away but as it is
- * accessed by the user-level code.
- */
-static vm_fault_t vma_fault(struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
 static __poll_t hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;
--- a/drivers/scsi/sg.c~a
+++ a/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_f
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };
--- a/drivers/usb/mon/mon_bin.c~a
+++ a/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct p
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct p
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
+{
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)
--- a/drivers/video/fbdev/core/fb_defio.c~a
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
--- a/drivers/video/fbdev/ssd1307fb.c~a
+++ a/drivers/video/fbdev/ssd1307fb.c
@@ -767,6 +767,8 @@ static int ssd1307fb_probe(struct i2c_cl
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);
--- a/fs/coredump.c~a
+++ a/fs/coredump.c
@@ -1608,7 +1608,7 @@ static unsigned long vma_dump_size(struc
 	}
 
 	/* Hugetlb memory check */
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
 			goto whole;
 		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
--- a/fs/fuse/dax.c~a
+++ a/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, str
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 
--- a/fs/hugetlbfs/inode.c~a
+++ a/fs/hugetlbfs/inode.c
@@ -108,7 +108,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * vma address alignment (but not the pgoff alignment) has
 	 * already been checked by prepare_hugepage_range.  If you add
 	 * any error returns here, do so after setting VM_HUGETLB, so
-	 * is_vm_hugetlb_page tests below unmap_region go the right
+	 * vma_is_hugetlb tests below unmap_region go the right
 	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
--- a/fs/proc/task_mmu.c~a
+++ a/fs/proc/task_mmu.c
@@ -2986,7 +2986,7 @@ static int pagemap_scan_pte_hole(unsigne
 	 * hugetlb differs, see pagemap_hugetlb_category().
 	 */
 	categories = p->cur_vma_category;
-	if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
+	if (userfaultfd_wp(vma) && !vma_is_hugetlb(vma))
 		categories |= PAGE_IS_WRITTEN;
 
 	if (!pagemap_scan_is_interesting_page(categories, p))
@@ -2999,7 +2999,7 @@ static int pagemap_scan_pte_hole(unsigne
 	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 		return ret;
 
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		err = pagemap_scan_hugetlb_hole_wp(vma, addr, end);
 	else
 		err = uffd_wp_range(vma, addr, end - addr, true);
@@ -3441,7 +3441,7 @@ static int show_numa_map(struct seq_file
 		seq_puts(m, " stack");
 	}
 
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		seq_puts(m, " huge");
 
 	/* Skip walking pages if gate VMA */
@@ -3470,7 +3470,7 @@ static int show_numa_map(struct seq_file
 	if (md->swapcache)
 		seq_printf(m, " swapcache=%lu", md->swapcache);
 
-	if (md->active < md->pages && !is_vm_hugetlb_page(vma))
+	if (md->active < md->pages && !vma_is_hugetlb(vma))
 		seq_printf(m, " active=%lu", md->active);
 
 	if (md->writeback)
--- a/include/asm-generic/tlb.h~a
+++ a/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
@@ -438,7 +438,7 @@ tlb_update_vma_flags(struct mmu_gather *
 	 * We rely on tlb_end_vma() to issue a flush, such that when we reset
 	 * these values the batch is empty.
 	 */
-	tlb->vma_huge = is_vm_hugetlb_page(vma);
+	tlb->vma_huge = vma_is_hugetlb(vma);
 	tlb->vma_exec = !!(vma->vm_flags & VM_EXEC);
 
 	/*
--- a/include/linux/hugetlb.h~a
+++ a/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
@@ -252,14 +251,14 @@ extern void __hugetlb_zap_end(struct vm_
 static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
 				     unsigned long *start, unsigned long *end)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		__hugetlb_zap_begin(vma, start, end);
 }
 
 static inline void hugetlb_zap_end(struct vm_area_struct *vma,
 				   struct zap_details *details)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		__hugetlb_zap_end(vma, details);
 }
 
diff --git a/include/linux/hugetlb_inline.h a/include/linux/hugetlb_inline.h
deleted file mode 100644
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
--- a/include/linux/mm.h~a
+++ a/include/linux/mm.h
@@ -578,14 +578,6 @@ enum {
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
-/*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
  *   IO tells people not to look at these pages
@@ -601,9 +593,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1614,6 +1603,185 @@ static inline bool vma_is_shared_maywrit
 }
 
 /**
+ * vma_flags_is_hugetlb() - Do the specified VMA flags indicate that the
+ * VMA is a hugetlb mapping?
+ * @flags: The VMA flags to test.
+ *
+ * Returns: true if the flags indicate a hugetlb mapping, false otherwise.
+ */
+static inline bool vma_flags_is_hugetlb(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+/**
+ * vma_is_hugetlb() - Is @vma a hugetlb mapping?
+ * @vma: The VMA to test.
+ *
+ * Returns: true if @vma is a hugetlb mapping, false otherwise.
+ */
+static inline bool vma_is_hugetlb(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_hugetlb(&vma->flags);
+}
+
+/**
+ * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
+ * contents of the VMA are managed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * Such a mapping is one established by a simple mmap() or brk() with no driver
+ * or other kernel component involved.
+ *
+ * They are rmappable, and core mm services rmap operations including reclaim,
+ * as well as population, CoW and merge/split (if eligible).
+ *
+ * Mappings which fail this test are those where this is not the case -
+ * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
+ *
+ * Returns: true if the flags indicate an mm-managed mapping.
+ */
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
+/**
+ * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_managed() for a description of this property.
+ *
+ * Returns: true if the VMA is mm-managed.
+ */
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a mapping of a fixed range of memory established by a driver),
+ * and thus cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_is_fixed_mapping(flags))
+		return false;
+
+	return true;
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
+/**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) for which two further things are true:
+ *
+ * 1. Everything mapped was placed there by core mm's fault path (no custom
+ *    ->fault).
+ * 2. What is mapped stays there until it is zapped or unmapped by the user.
+ *
+ * These mappings are the only ones which can be sensibly locked, merged, dumped
+ * or be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages these, and that the mappings will remain there.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	if (!vma_flags_is_mm_managed(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Core mm may discard droppable memory at any time. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
+/**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
  *
@@ -4609,7 +4777,7 @@ static inline void mmap_action_map_kerne
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
@@ -4633,10 +4801,55 @@ static inline void mmap_action_map_kerne
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+			  struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
+		state->__folio = folio;
+		state->__nr_pages = min(state->nr_pages_remain,
+					folio_nr_pages(folio));
+	} else {
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
+		state->__page = page;
+		state->__nr_pages = 1;
+	}
+}
+
+static inline void
+discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
+				struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->__page_arr = page_arr;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
@@ -4754,9 +4967,6 @@ int remap_pfn_range(struct vm_area_struc
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
--- a/include/linux/mm_types.h~a
+++ a/include/linux/mm_types.h
@@ -815,11 +815,47 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct folio *__folio;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +880,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
--- a/include/linux/pagemap.h~a
+++ a/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
--- a/include/linux/rmap.h~a
+++ a/include/linux/rmap.h
@@ -888,7 +888,7 @@ struct page_vma_mapped_walk {
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 {
 	/* HugeTLB pte is set to the relevant page table entry without pte_mapped. */
-	if (pvmw->pte && !is_vm_hugetlb_page(pvmw->vma))
+	if (pvmw->pte && !vma_is_hugetlb(pvmw->vma))
 		pte_unmap(pvmw->pte);
 	if (pvmw->ptl)
 		spin_unlock(pvmw->ptl);
--- a/include/linux/userfaultfd_k.h~a
+++ a/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
--- a/kernel/bpf/arena.c~a
+++ a/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }
--- a/kernel/events/core.c~a
+++ a/kernel/events/core.c
@@ -9818,7 +9818,7 @@ static void perf_event_mmap_event(struct
 
 	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		flags |= MAP_HUGETLB;
 
 	if (file) {
--- a/kernel/events/uprobes.c~a
+++ a/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
--- a/kernel/sched/fair.c~a
+++ a/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
@@ -4417,7 +4416,7 @@ retry_pids:
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			vma_is_hugetlb(vma) || !vma_is_mm_managed(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
--- a/mm/folio.c~a
+++ a/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *fol
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
--- a/mm/gup.c~a
+++ a/mm/gup.c
@@ -621,7 +621,7 @@ static struct page *no_page_table(struct
 	 * But we can only make this optimization where a hole would surely
 	 * be zero-filled if handle_mm_fault() actually did handle it.
 	 */
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		struct hstate *h = hstate_vma(vma);
 
 		if (!hugetlbfs_pagecache_present(h, vma, address))
@@ -1213,7 +1213,7 @@ static int check_vma_flags(struct vm_are
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
 		return -EOPNOTSUPP;
 
-	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
+	if ((gup_flags & FOLL_SPLIT_PMD) && vma_is_hugetlb(vma))
 		return -EOPNOTSUPP;
 
 	if (vma_is_secretmem(vma))
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_a
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order
--- a/mm/huge_memory.c~a
+++ a/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(cons
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || !vma_is_mm_managed(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -212,11 +204,14 @@ unsigned long __thp_vma_allowable_orders
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Mappings not managed by core mm cannot be reliably reconstructed from
+	 * page faults, and fixed mappings (including hugetlb) may well be
+	 * mm-managed - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
@@ -3053,7 +3048,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3209,7 +3204,7 @@ static void __split_huge_pmd_locked(stru
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (!vma_is_mm_managed(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4776,11 +4771,9 @@ static inline bool vma_not_suitable_for_
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (!vma_is_mm_managed(vma))
 		return true;
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return true;
 
 	return false;
--- a/mm/hugetlb.c~a
+++ a/mm/hugetlb.c
@@ -1147,7 +1147,7 @@ static inline struct resv_map *inode_res
 
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
-	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 	if (vma->vm_flags & VM_MAYSHARE) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 		struct inode *inode = mapping->host;
@@ -1162,7 +1162,7 @@ static struct resv_map *vma_resv_map(str
 
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
 {
-	VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 	VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
 
 	set_vma_private_data(vma, (unsigned long)map);
@@ -1170,7 +1170,7 @@ static void set_vma_resv_map(struct vm_a
 
 static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 {
-	VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 	VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
 
 	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
@@ -1178,7 +1178,7 @@ static void set_vma_resv_flags(struct vm
 
 static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
 {
-	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 
 	return (get_vma_private_data(vma) & flag) != 0;
 }
@@ -1192,7 +1192,7 @@ bool __vma_private_lock(struct vm_area_s
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
-	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 	/*
 	 * Clear vm_private_data
 	 * - For shared mappings this is a per-vma semaphore that may be
@@ -5276,7 +5276,7 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long last_addr_mask;
 
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	WARN_ON(!is_vm_hugetlb_page(vma));
+	WARN_ON(!vma_is_hugetlb(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
@@ -7502,6 +7502,6 @@ void hugetlb_unshare_all_pmds(struct vm_
  */
 void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		clear_vma_resv_huge_pages(vma);
 }
--- a/mm/internal.h~a
+++ a/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
@@ -213,6 +214,24 @@ static inline void *folio_raw_mapping(co
 }
 
 /*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
+/*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
  * mutated.
@@ -224,8 +243,12 @@ static inline void *folio_raw_mapping(co
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long orig_start = vma->vm_start;
+	const unsigned long orig_end = vma->vm_end;
+	const vma_flags_t orig_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -238,26 +261,16 @@ static inline int mmap_file(struct file
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(orig_start, orig_end, &orig_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = orig_start;
+		vma->vm_end = orig_end;
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
@@ -957,15 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -982,7 +987,12 @@ static inline void munlock_vma_folio(str
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
@@ -1102,11 +1112,9 @@ static inline struct file *maybe_unlock_
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_mm_backed(vma))
 		return false;
-	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
+	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
 	return vma != get_gate_vma(current->mm);
 }
@@ -1501,6 +1509,12 @@ int remap_pfn_range_prepare(struct vm_ar
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
--- a/mm/ksm.c~a
+++ a/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_mm_backed(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
--- a/mm/madvise.c~a
+++ a/mm/madvise.c
@@ -882,7 +882,7 @@ bool madvise_dontneed_free_valid_vma(str
 	int behavior = madv_behavior->behavior;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 
-	if (!is_vm_hugetlb_page(vma)) {
+	if (!vma_is_hugetlb(vma)) {
 		unsigned int forbidden = VM_PFNMAP;
 
 		if (behavior != MADV_DONTNEED_LOCKED)
@@ -1057,19 +1057,25 @@ static long madvise_remove(struct madvis
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)
@@ -1396,7 +1402,7 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;
@@ -1415,8 +1421,8 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!is_vm_hugetlb_page(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;
--- a/mm/memory.c~a
+++ a/mm/memory.c
@@ -1564,7 +1564,7 @@ copy_page_range(struct vm_area_struct *d
 	if (!vma_needs_copy(dst_vma, src_vma))
 		return 0;
 
-	if (is_vm_hugetlb_page(src_vma))
+	if (vma_is_hugetlb(src_vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
 	/*
@@ -2189,7 +2189,7 @@ static void __zap_vma_range(struct mmu_g
 	if (vma->vm_file && !reaping)
 		uprobe_munmap(vma, start, end);
 
-	if (unlikely(is_vm_hugetlb_page(vma))) {
+	if (unlikely(vma_is_hugetlb(vma))) {
 		zap_flags_t zap_flags = details ? details->zap_flags : 0;
 
 		VM_WARN_ON_ONCE(reaping);
@@ -2324,7 +2324,7 @@ void zap_vma_range_batched(struct mmu_ga
 	 */
 	__zap_vma_range(tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		/*
 		 * flush tlb and free resources before hugetlb_zap_end(), to
 		 * avoid concurrent page faults' allocation failure.
@@ -2354,19 +2354,20 @@ void zap_vma_range(struct vm_area_struct
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a VMA which is not
+ * mm-managed
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is mm-managed.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   vma_is_mm_managed(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
@@ -2620,17 +2621,23 @@ int vm_insert_pages(struct vm_area_struc
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2639,7 +2646,6 @@ int map_kernel_pages_prepare(struct vm_a
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2651,7 +2657,98 @@ int map_kernel_pages_complete(struct vm_
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
+
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops || !ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+				  struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
+		return insert_page(vma, addr, state->__page,
+				   vma->vm_page_prot, /*mkwrite=*/false);
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+		return insert_pages(vma, addr, state->__page_arr,
+				    &nr_pages, vma->vm_page_prot);
+
+	/* Compound folio - have to iterate through each page. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = folio_page(state->__folio, i);
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				  /*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
 
 /**
  * vm_insert_page - insert single page into user vma
@@ -6851,7 +6948,7 @@ vm_fault_t handle_mm_fault(struct vm_are
 
 	lru_gen_enter_fault(vma);
 
-	if (unlikely(is_vm_hugetlb_page(vma)))
+	if (unlikely(vma_is_hugetlb(vma)))
 		ret = hugetlb_fault(vma->vm_mm, vma, address, flags);
 	else
 		ret = __handle_mm_fault(vma, address, flags);
@@ -7721,12 +7818,12 @@ void ptlock_free(struct ptdesc *ptdesc)
 
 void vma_pgtable_walk_begin(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		hugetlb_vma_lock_read(vma);
 }
 
 void vma_pgtable_walk_end(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		hugetlb_vma_unlock_read(vma);
 }
--- a/mm/mempolicy.c~a
+++ a/mm/mempolicy.c
@@ -2018,7 +2018,7 @@ bool vma_migratable(struct vm_area_struc
 	if (vma_is_dax(vma))
 		return false;
 
-	if (is_vm_hugetlb_page(vma) &&
+	if (vma_is_hugetlb(vma) &&
 		!hugepage_migration_supported(hstate_vma(vma)))
 		return false;
 
--- a/mm/migrate_device.c~a
+++ a/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct mig
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || is_vm_hugetlb_page(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;
--- a/mm/mlock.c~a
+++ a/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_s
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, u
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
--- a/mm/mmap.c~a
+++ a/mm/mmap.c
@@ -1786,7 +1786,7 @@ __latent_entropy int dup_mmap(struct mm_
 		/*
 		 * Copy/update hugetlb private vma information.
 		 */
-		if (is_vm_hugetlb_page(tmp))
+		if (vma_is_hugetlb(tmp))
 			hugetlb_dup_vma_private(tmp);
 
 		/*
--- a/mm/mmu_gather.c~a
+++ a/mm/mmu_gather.c
@@ -480,7 +480,7 @@ void tlb_gather_mmu_vma(struct mmu_gathe
 {
 	tlb_gather_mmu(tlb, vma->vm_mm);
 	tlb_update_vma_flags(tlb, vma);
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		/* All entries have the same size. */
 		tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
 }
--- a/mm/mprotect.c~a
+++ a/mm/mprotect.c
@@ -717,7 +717,7 @@ long change_protection(struct mmu_gather
 	    (cp_flags & MM_CP_UFFD_RWP))
 		newprot = PAGE_NONE;
 
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
 	else
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    !vma_flags_is_mm_managed(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
--- a/mm/mremap.c~a
+++ a/mm/mremap.c
@@ -812,7 +812,7 @@ unsigned long move_page_tables(struct pa
 	if (!pmc->len_in)
 		return 0;
 
-	if (is_vm_hugetlb_page(pmc->old))
+	if (vma_is_hugetlb(pmc->old))
 		return move_hugetlb_page_tables(pmc->old, pmc->new, pmc->old_addr,
 						pmc->new_addr, pmc->len_in);
 
@@ -1769,7 +1769,7 @@ static bool vma_multi_allowed(struct vm_
 	/* Known good. */
 	if (vma_is_shmem(vma))
 		return true;
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return true;
 	if (file->f_op->get_unmapped_area == thp_get_unmapped_area)
 		return true;
@@ -1792,7 +1792,7 @@ static int check_prep_vma(struct vma_rem
 		return -EPERM;
 
 	/* Align to hugetlb page size, if required. */
-	if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm))
+	if (vma_is_hugetlb(vma) && !align_hugetlb(vrm))
 		return -EINVAL;
 
 	vrm_set_delta(vrm);
@@ -1822,8 +1822,7 @@ static int check_prep_vma(struct vma_rem
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1861,7 +1860,7 @@ static int check_prep_vma(struct vma_rem
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
--- a/mm/page_vma_mapped.c~a
+++ a/mm/page_vma_mapped.c
@@ -109,7 +109,7 @@ static bool check_pte(struct page_vma_ma
 	unsigned long pfn;
 	pte_t ptent;
 
-	if (is_vm_hugetlb_page(pvmw->vma))
+	if (vma_is_hugetlb(pvmw->vma))
 		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
 				      pvmw->pte);
 	else
@@ -206,7 +206,7 @@ bool page_vma_mapped_walk(struct page_vm
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
 
-	if (unlikely(is_vm_hugetlb_page(vma))) {
+	if (unlikely(vma_is_hugetlb(vma))) {
 		struct hstate *hstate = hstate_vma(vma);
 		unsigned long size = huge_page_size(hstate);
 		/* The only possible mapping was handled on last iteration */
--- a/mm/pagewalk.c~a
+++ a/mm/pagewalk.c
@@ -408,7 +408,7 @@ static int __walk_page_range(unsigned lo
 	int err = 0;
 	struct vm_area_struct *vma = walk->vma;
 	const struct mm_walk_ops *ops = walk->ops;
-	bool is_hugetlb = is_vm_hugetlb_page(vma);
+	bool is_hugetlb = vma_is_hugetlb(vma);
 
 	/* We do not support hugetlb PTE installation. */
 	if (ops->install_pte && is_hugetlb)
--- a/mm/rmap.c~a
+++ a/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct foli
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
@@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct foli
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
@@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct fo
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
 	}
--- a/mm/swapfile.c~a
+++ a/mm/swapfile.c
@@ -2707,7 +2707,7 @@ static int unuse_mm(struct mm_struct *mm
 	if (check_stable_address_space(mm))
 		goto unlock;
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
+		if (vma->anon_vma && !vma_is_hugetlb(vma)) {
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
--- a/mm/userfaultfd.c~a
+++ a/mm/userfaultfd.c
@@ -237,7 +237,7 @@ static int mfill_get_vma(struct mfill_st
 	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
 		goto out_unlock;
 
-	if (is_vm_hugetlb_page(dst_vma))
+	if (vma_is_hugetlb(dst_vma))
 		return 0;
 
 	ops = vma_uffd_ops(dst_vma);
@@ -804,7 +804,7 @@ retry:
 		}
 
 		err = -ENOENT;
-		if (!is_vm_hugetlb_page(dst_vma))
+		if (!vma_is_hugetlb(dst_vma))
 			goto out_unlock_vma;
 
 		err = -EINVAL;
@@ -967,7 +967,7 @@ static __always_inline ssize_t mfill_ato
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
-	if (is_vm_hugetlb_page(state.vma))
+	if (vma_is_hugetlb(state.vma))
 		return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
 					     src_start, len, flags);
 
@@ -1114,7 +1114,7 @@ static int mwriteprotect_range(struct us
 			break;
 		}
 
-		if (is_vm_hugetlb_page(dst_vma)) {
+		if (vma_is_hugetlb(dst_vma)) {
 			err = -EINVAL;
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
 			if ((start & page_mask) || (len & page_mask))
@@ -1172,7 +1172,7 @@ int mrwprotect_range(struct userfaultfd_
 		if (!userfaultfd_rwp(dst_vma))
 			return -ENOENT;
 
-		if (is_vm_hugetlb_page(dst_vma)) {
+		if (vma_is_hugetlb(dst_vma)) {
 			unsigned long page_mask;
 
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
@@ -1755,10 +1755,16 @@ static inline bool move_splits_huge_pmd(
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with mappings not managed by core mm. */
+	if (!vma_is_mm_managed(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	return !vma_is_hugetlb(vma);
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2147,10 +2153,11 @@ static bool vma_can_userfault(struct vm_
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Only mm-backed memory can have its faults handled by userspace. */
+	if (!vma_is_mm_backed(vma))
 		return false;
-
-	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;
@@ -2320,7 +2327,7 @@ static int userfaultfd_register_range(st
 		 */
 		userfaultfd_set_ctx(vma, ctx, vm_flags);
 
-		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
+		if (vma_is_hugetlb(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
 
 skip:
@@ -2896,7 +2903,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * (sleepable) vma lock can modify the current task state, that
 	 * must be before explicitly calling set_current_state().
 	 */
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		hugetlb_vma_lock_read(vma);
 
 	spin_lock_irq(&ctx->fault_pending_wqh.lock);
@@ -2913,7 +2920,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	set_current_state(blocking_state);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		must_wait = userfaultfd_huge_must_wait(ctx, vmf, reason);
 		hugetlb_vma_unlock_read(vma);
 	} else {
@@ -3745,7 +3752,7 @@ static int userfaultfd_register(struct u
 	 * If the first vma contains huge pages, make sure start address
 	 * is aligned to huge page size.
 	 */
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
 
 		if (start & (vma_hpagesize - 1))
@@ -3796,7 +3803,7 @@ static int userfaultfd_register(struct u
 		 * If this vma contains ending address, and huge pages
 		 * check alignment.
 		 */
-		if (is_vm_hugetlb_page(cur) && end <= cur->vm_end &&
+		if (vma_is_hugetlb(cur) && end <= cur->vm_end &&
 		    end > cur->vm_start) {
 			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
 
@@ -3832,7 +3839,7 @@ static int userfaultfd_register(struct u
 		/*
 		 * Note vmas containing huge pages
 		 */
-		if (is_vm_hugetlb_page(cur))
+		if (vma_is_hugetlb(cur))
 			basic_ioctls = true;
 
 		found = true;
@@ -3918,7 +3925,7 @@ static int userfaultfd_unregister(struct
 	 * If the first vma contains huge pages, make sure start address
 	 * is aligned to huge page size.
 	 */
-	if (is_vm_hugetlb_page(vma)) {
+	if (vma_is_hugetlb(vma)) {
 		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
 
 		if (start & (vma_hpagesize - 1))
--- a/mm/util.c~a
+++ a/mm/util.c
@@ -1224,16 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
 	if (err)
-		return err;
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
@@ -1389,6 +1401,15 @@ static int call_vma_mapped(struct vm_are
 	return 0;
 }
 
+/* An mmap action failed under the compatibility layer - unmap and close. */
+static void compat_mmap_action_abort(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	zap_vma_range(vma, vma->vm_start, vma_pages(vma) << PAGE_SHIFT);
+#endif
+	vma_close(vma);
+}
+
 static int mmap_action_finish(struct vm_area_struct *vma,
 			      struct mmap_action *action, int err,
 			      bool is_compat)
@@ -1400,12 +1421,13 @@ static int mmap_action_finish(struct vm_
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	/*
-	 * If this is invoked from the compatibility layer, post-mmap() hook
-	 * logic will handle cleanup for us.
-	 */
-	if (!err || is_compat)
+	if (!err)
+		return 0;
+
+	if (is_compat) {
+		compat_mmap_action_abort(vma);
 		return err;
+	}
 
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1455,8 +1477,10 @@ int mmap_action_prepare(struct vm_area_d
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1486,9 +1510,12 @@ int mmap_action_complete(struct vm_area_
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1509,7 +1536,8 @@ int mmap_action_prepare(struct vm_area_d
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1530,7 +1558,8 @@ int mmap_action_complete(struct vm_area_
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
--- a/mm/vma.c~a
+++ a/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -599,7 +599,7 @@ __split_vma(struct vma_iterator *vmi, st
 	 * boundary.
 	 */
 	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		hugetlb_split(vma, addr);
 
 	if (new_below) {
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struc
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_ran
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
@@ -2248,7 +2251,7 @@ bool vma_wants_writenotify(struct vm_are
 	 * Do we need to track softdirty? hugetlb does not support softdirty
 	 * tracking yet.
 	 */
-	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
+	if (vma_soft_dirty_enabled(vma) && !vma_is_hugetlb(vma))
 		return true;
 
 	/* Do we need write faults for uffd-wp tracking? */
@@ -2367,7 +2370,7 @@ int mm_take_all_locks(struct mm_struct *
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
-				is_vm_hugetlb_page(vma))
+				vma_is_hugetlb(vma))
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 
@@ -2376,7 +2379,7 @@ int mm_take_all_locks(struct mm_struct *
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
-				!is_vm_hugetlb_page(vma))
+				!vma_is_hugetlb(vma))
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 
@@ -2462,7 +2465,7 @@ void mm_drop_all_locks(struct mm_struct
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2511,7 +2514,7 @@ static void vms_abort_munmap_vmas(struct
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2521,7 +2524,7 @@ static void set_desc_from_map(struct vm_
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2601,6 +2604,10 @@ static int __mmap_setup(struct mmap_stat
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2608,37 +2615,52 @@ static int __mmap_new_file_vma(struct mm
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
+		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
+		vma->vm_file = file;
+		/* Only safe once unmapped. */
+		vma_close(vma);
+
+		if (map_same_file(map))
+			fput(map->vm_file);
+		vma->vm_file = NULL;
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
 	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
+	 * If the VMA is still eligible for mlock(), reinstate any original
+	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
 	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2646,7 +2668,7 @@ static int __mmap_new_file_vma(struct mm
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2658,7 +2680,7 @@ static bool map_is_private(const struct
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2703,7 +2725,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2716,11 +2738,6 @@ static int __mmap_new_vma(struct mmap_st
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2783,6 +2800,103 @@ static void __mmap_complete(struct mmap_
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	if (vma_flags_is_mm_managed(flags)) {
+		/* mm-managed mappings may not set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
+			 unsigned long curr_start, unsigned long curr_end,
+			 const vma_flags_t *orig_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(orig_start != curr_start || orig_end != curr_end))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(orig_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	/* mm-managed mappings may not clear VMA_MAYWRITE_BIT. */
+	if (vma_flags_is_mm_managed(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @orig_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc)
+{
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 *
+	 * This is checked after mmap_action_prepare(), as it may update the VMA
+	 * flags and therefore whether the VMA can be merged.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
+	return mmap_validate(orig_desc->start, orig_desc->end,
+			     desc->start, desc->end,
+			     &orig_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @orig_start: The start of the mapping prior to the mmap hook.
+ * @orig_end: The end of the mapping prior to the mmap hook.
+ * @orig_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(orig_start, orig_end, start, end, orig_flags,
+			     flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2809,13 +2923,18 @@ static int call_action_prepare(struct mm
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc orig_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
+	/* Update first so file refcount tracked correctly. */
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
+
 	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
@@ -2824,12 +2943,13 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
@@ -2841,7 +2961,7 @@ static int call_mmap_prepare(struct mmap
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2860,7 +2980,7 @@ static void set_vma_user_defined_fields(
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2883,6 +3003,20 @@ static bool can_set_ksm_flags_early(stru
 	return false;
 }
 
+static void map_put_vm_file(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2937,7 +3071,10 @@ static unsigned long __mmap_region(struc
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		map_put_vm_file(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2951,13 +3088,7 @@ unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	map_put_vm_file(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
@@ -3452,10 +3583,15 @@ int __vm_munmap(unsigned long start, siz
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
--- a/mm/vma.h~a
+++ a/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_d
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 
@@ -785,14 +787,19 @@ struct vm_area_struct *vm_area_alloc(str
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -841,6 +848,20 @@ static inline bool map_deny_write_exec(c
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long orig_start,
+				     unsigned long orig_end,
+				     const vma_flags_t *orig_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
--- a/mm/vma_internal.h~a
+++ a/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>
--- a/mm/vmscan.c~a
+++ a/mm/vmscan.c
@@ -3515,13 +3515,14 @@ static int should_skip_vma(unsigned long
 	if (!vma_is_accessible(vma))
 		return true;
 
-	if (is_vm_hugetlb_page(vma))
+	if (vma_is_hugetlb(vma))
 		return true;
 
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || !vma_is_mm_managed(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))
@@ -4461,8 +4462,8 @@ bool lru_gen_look_around(struct page_vma
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */
--- a/security/selinux/selinuxfs.c~a
+++ a/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 
--- a/sound/core/pcm_native.c~a
+++ a/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*
--- a/tools/testing/vma/include/dup.h~a
+++ a/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
@@ -454,17 +446,20 @@ static __always_inline bool vma_flags_em
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +478,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
@@ -1359,15 +1358,25 @@ static inline int vfs_mmap_prepare(struc
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
 	if (err)
 		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		return err;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
@@ -1647,3 +1656,48 @@ static inline bool file_is_dev_zero(cons
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_is_fixed_mapping(flags))
+		return false;
+
+	return true;
+}
--- a/tools/testing/vma/include/stubs.h~a
+++ a/tools/testing/vma/include/stubs.h
@@ -193,7 +193,7 @@ static inline bool mapping_can_writeback
 	return true;
 }
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool vma_is_hugetlb(struct vm_area_struct *vma)
 {
 	return false;
 }
--- a/tools/testing/vma/tests/merge.c~a
+++ a/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
a.patch
b.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
selftests-mm-build-page-frag-test-with-the-kernel.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

