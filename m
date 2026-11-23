Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454931;
	b=FyZUq5ZTur3QBTg5QTe6ltIxg4F+IbJoRALNkvKA7/J0PxaEWGOyFDfdw+wfmgW1HlI/
	 z7ZIc29fyEtMKRBcSEXSvUGrruaGv3GnaV2UWiAOviEYaKuzgK27fohsHKrM2pGfTmtXV
	 yQBlZfO/vEwriUYgugU3IbyNnqnGgU+YK/85Vpa8yIuGiNHT5b6H+DhPH5hFlrc6X3mNN
	 OPAf5dDAr0so3+fWwgBQMsgQxkLWVim5JF/rzkr9U+0g0AcMBx/U2l7hitqz181p1MA6m
	 PI+/cF+Li3qdbGZ8o6RK99GbPrOmC4jYBd0GUeU0NMu+/kwOLIC4Tkkq2s5pwJG3bag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454931;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=vjpKU6pyShtGR42Rx6NyzA8YsSYRbIRnIAtq7mcfeiA=;
	b=1J3KXhejfHMdFyqnsF8BVM8PM/g9aXz3DJ04Hak5DqFZYnJac/CHQL4R1p/gwdi3voFy
	 W2P3+ABM0ZFS7iJb+4rKf4HLI73sA3OFNYnlXsEiea+dMPNM0QJFig187c9Gf47MsfjK2
	 Db87EhkVFdexq/NiW2JY6/TRazhFwdqZY7szaSHvld7XHAH9K/LFx1fkjl6T6xke9DQZB
	 Xn/OExf2jr8bpRVch98ZHNziG3b/po6yiAw0sLkfeqN8kQZY5eb/oYvRRUbEan1SmRutA
	 3/9kGo8w72qKgWSm9QDRSEvlPFaUMsXMkpFrq866X7TSPm5lDl7jdPtm3ZPnAVAEV0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=md1KCphp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BF606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=md1KCphp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375C41F000C6;
	Mon, 23 Nov 2026 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454930;
	bh=vjpKU6pyShtGR42Rx6NyzA8YsSYRbIRnIAtq7mcfeiA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=md1KCphpUN0XPo7ejY3kas2plc0xyE+GR0ZQJxzQmicoNqnNQHuQ4mfLcBYmNMYxp
	 iUhi1etM5nJLYmcFNYVBwD8QLNH5/Oj7OwKKKIHHvcCQLrG9JYVTU0sZ3W7WFJdA58
	 hoG4SoQ2T+PI4r0QLt+ATVLgYjcz+FdiMNptvUms=
Date: Mon, 23 Nov 2026 09:28:49 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,corbet@lwn.net,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-6-sj@kernel.org>
References: <20261123151309.82675-6-sj@kernel.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch added to mm-new branch
Message-Id: <20261123172850.375C41F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:06 -0800

Update DAMON usage document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Link: https://patch.msgid.link/20261123151309.82675-6-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 Documentation/admin-guide/mm/damon/usage.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -105,7 +105,10 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,
+    │ │ │ │ │ │ │     nr_applied,sz_applied,sz_ops_filter_passed,
+    │ │ │ │ │ │ │     sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,
+    │ │ │ │ │ │ │     max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
@@ -631,8 +634,8 @@ online analysis or tuning of the schemes
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
-``max_nr_snapshots``), respectively.
+``sz_ops_filter_passed``, ``sz_ops_filter_passed_last``,
+``qt_exceeds``, ``nr_snapshots`` and ``max_nr_snapshots``), respectively.
 
 The files are not updated in real time by default.  Users should ask DAMON
 sysfs interface to periodically update those using ``refresh_ms``, or do a one
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

