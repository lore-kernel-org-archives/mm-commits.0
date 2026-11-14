Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794628243;
	b=E0U9SD0jC2y4d/lqOs3jBtRKryW0WehsQR3FsSb1YaKKnuVpQks2yhKjkvvkFlf4MHFk
	 WjwUxUN9tnhkEmFYk69MdK9IbFB3p2wnBqBNHl+HKnfAp78Xw7MMlHoQt/wr6/JU98bPq
	 l2OQbC7iWF54+MYn5OV4BrA8Ga5L7QBAgk/cfsglWXwAU0IPDEkU0kSgmt+AhpoUZmfBx
	 bCByzUoH5vW5zfjarLGabY12xXlRrOzv8qdGvLG2vLLK8Vm0c8lKuvlP2ry/ym/KtWWMm
	 gerwATD29QEjuljDiiAnQhgPdLI4Lsh3H/RuD01Bp3s5XDwJJd7Zujyg5MxhU0uHjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794628243;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KOAujgWhSnbK4vuBS0U5BsZyu6nJYOTXcBvLbmbUkRs=;
	b=5tSLbqwgBTxVSK9rhCHTpu1xP5BbxhjAy7t4V3YSyLS9YGCqYH2UnC2mWVfoN5YflcYD
	 K6Ht4kUQWDCQDgJh8Rm769+dDT4n8Ba2JVr+/7Bbme26X69RFx3ooQLtgdALIvsue3fqE
	 i2qvuWF/mUl2XxlfpjtDH5+7LBK6Qb8h7pMGMKe/L0zU99zTkwuUWOqrR6AjM3BrtBI4m
	 pHLILdAs9iqT2MuMhn6fUVs1+goiLADUD+4+m9Jll9y6JS3YGqySmA33PQXrr/4tNyyiY
	 W8pE4xfRo8RKY+got4K1+vCrE1QHIuRWfR7WAlF5sWq2i7S2x4TIDfrFf+CSRuy/QHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MqHivRab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE70606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 03:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MqHivRab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC81F000C4;
	Sat, 14 Nov 2026 03:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794628243;
	bh=KOAujgWhSnbK4vuBS0U5BsZyu6nJYOTXcBvLbmbUkRs=;
	h=Date:To:From:Subject;
	b=MqHivRabbe1HIVMxpB7YAUgbLlI8eaIPXkXcCwQijEFNuFoC6A0K2jJ+UPGZ+FkSR
	 rSR+gLYUkbiKiAHs/BK1yLBI06ux+t6kYQ2O9ElwmGkLh1HQzXBQHIUf5utDsbbm+x
	 29RmT3B9vPjjFcxPlaqVp9ejFPTHjv+xRz8jo2M0=
Date: Fri, 13 Nov 2026 19:50:43 -0800
To: mm-commits@vger.kernel.org,wy@wyuan.org,users@kernel.org,
	skhan@linuxfoundation.org,si.yanteng@linux.dev,rdunlap@infradead.org,
	petr.pavlu@suse.com,joe@perches.com,federico.vaga@vaga.pv.it,
	dzm91@hust.edu.cn,corbet@lwn.net,chenyou910331@gmail.com,
	carlos.bilbao@kernel.org,avadhut.naik@amd.com,alexs@kernel.org,
	akiyks@gmail.com,konstantin@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-only-use-the-rest-as-a-fallback.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261114035043.66BC81F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: get_maintainer: only use THE REST as a fallback
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     get_maintainer-only-use-the-rest-as-a-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-only-use-the-rest-as-a-fallback.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: get_maintainer: only use THE REST as a fallback
Date: Fri, 13 Nov 2026 18:02:45 -0500

Patch series "get_maintainer: stop sending every patch to LKML", v3.

LKML has become mostly a firehose of patches that are already going to a
subsystem list.  The reason is THE REST: it matches every file in the
tree, so get_maintainer.pl adds linux-kernel@vger.kernel.org to every
single patch.  During the week of Oct 1-7, 2026:

  - LKML carried 13,641 messages (~1,950/day), 90% of which were also
    sent to at least one other list;
  - with ~2,100 subscribers, that is about 29 million deliveries per
    week for LKML alone.

This problem is becoming urgent and untenable.  The increased volume of
patches sent using AI tooling has resulted in dramatically higher delivery
queues and if this change is not implemented, we will have to start
force-unsubscribing addresses that do not show any developer activity or
use similar drastic measures.

This issue came up during the 2026 Maintainer Summit and the consensus was
that "always include linux-kernel for every patch" was never the intent.

This series makes THE REST a fallback as initially intended: it is only
added for a file when no other matching MAINTAINERS section provides a
mailing list that get_maintainer.pl would actually output for it.  Patch 2
updates submitting-patches.rst, which currently tells submitters to send
every patch to LKML.

Several v1 reviewers asked for a catch-all list that would keep carrying
every patch for those who want to follow all kernel development.  That is
a worthwhile discussion, but it is separate from this series, which only
restores THE REST to its original role.

Translation maintainers are Cc'd because the it_IT, ja_JP, sp_SP, zh_CN
and zh_TW versions of submitting-patches.rst carry the same "send every
patch to LKML" advice and will need a follow-up update once the English
text is settled.


This patch (of 2):

THE REST matches every file in the tree via "F: *" and "F: */", so
get_maintainer.pl currently adds linux-kernel@vger.kernel.org to every
patch, regardless of whether the touched files already belong to a
subsystem with its own mailing list.

Only add THE REST for a file when no other matching section provides a
mailing list that get_maintainer.pl would actually output. Lists marked
"subscribers-only" are omitted unless --s is given, and lists marked
"moderated" are omitted with --no-moderated, so such lists don't count
as a destination in those cases. Files that match no section, or only
sections without such a list, still fall back to THE REST, so every
patch keeps reaching at least one known-public mailing list.

Link: https://lore.kernel.org/20261113-get-maintainer-the-rest-fallback-v3-0-36ee5a3e8d13@linuxfoundation.org
Link: https://lore.kernel.org/20261113-get-maintainer-the-rest-fallback-v3-1-36ee5a3e8d13@linuxfoundation.org
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Akira Yokosawa <akiyks@gmail.com>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Avadhut Naik <avadhut.naik@amd.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Chen-Yu Yeh <chenyou910331@gmail.com>
Cc: Weijie Yuan <wy@wyuan.org>
Cc: <users@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>

 scripts/get_maintainer.pl |   43 ++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/scripts/get_maintainer.pl~get_maintainer-only-use-the-rest-as-a-fallback
+++ a/scripts/get_maintainer.pl
@@ -959,6 +959,15 @@ sub get_maintainers {
 	    $tvi = $end + 1;
 	}
 
+	# THE REST matches every file, so only fall back to it when no
+	# other matching section provides a mailing list for this file
+	# that we would actually output with the current options.
+	my ($the_rest) = grep { get_section_name($_) eq "THE REST" } keys %hash;
+	if (defined($the_rest) &&
+	    grep { $_ != $the_rest && section_has_list($_) } keys %hash) {
+	    delete $hash{$the_rest};
+	}
+
 	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	    add_categories($line, "");
 	    if ($sections) {
@@ -1295,6 +1304,40 @@ sub find_ending_index {
     return $index;
 }
 
+sub get_section_name {
+    my ($index) = @_;
+
+    return $typevalue[find_starting_index($index)];
+}
+
+sub section_has_list {
+    my ($index) = @_;
+
+    my $start = find_starting_index($index);
+    my $end = find_ending_index($index);
+    for (my $i = $start; $i < $end; $i++) {
+	next if ($typevalue[$i] !~ m/^L:\s*(.*)/);
+	my $list_additional = "";
+	if ($1 =~ m/[^\s]+\s+(.*)$/) {
+	    $list_additional = $1;
+	}
+	return 1 if (list_is_selected($list_additional));
+    }
+    return 0;
+}
+
+# Must match the list selection in add_categories()
+sub list_is_selected {
+    my ($list_additional) = @_;
+
+    if ($list_additional =~ m/subscribers-only/) {
+	return $email_subscriber_list;
+    } elsif ($list_additional =~ m/moderated/) {
+	return $email_list && $email_moderated_list;
+    }
+    return $email_list;
+}
+
 sub get_subsystem_name {
     my ($index) = @_;
 
_

Patches currently in -mm which might be from konstantin@linuxfoundation.org are

get_maintainer-only-use-the-rest-as-a-fallback.patch
docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch

