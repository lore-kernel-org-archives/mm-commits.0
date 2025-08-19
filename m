Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5233827E1AC
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642045; cv=none; b=hNBVO2Xae7f14BRs/0m9a3q1bTFOcZJK6N2LerRBXLNBc50+7c8lM48Jfux9So+CwVpJtOIPekzYVfwwtIdqhmJpli8AUf9i9BZ4qn+2ZpeDSwZWU6alvwgYcAfB9xHMtlPm4xo9SSviJZHA0qsu2q5+n4dRdgtUuR3E2D/Bduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642045; c=relaxed/simple;
	bh=jz1zsn6jGnvhp8fffMv/2FhBh+whsWahW1jrJdS5+Fc=;
	h=Date:To:From:Subject:Message-Id; b=jLbJv3xi3fdfV6HMQHPCqbsP26eN6UoO99BrmJyFDSvw7VbQXWdJMMY9omoFuCBb/Qy+ztFyzHYbfGcXF6iKb7S8kp4IJ0jbtGXINBV3ppwZuEpuNcrKlUgC2+gH6i2VXQ4j7m4A+MmHoYeKPJfk72KLVLbVwgifDq+elbyAsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=smX5gmNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="smX5gmNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E01C113CF;
	Tue, 19 Aug 2025 22:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642044;
	bh=jz1zsn6jGnvhp8fffMv/2FhBh+whsWahW1jrJdS5+Fc=;
	h=Date:To:From:Subject:From;
	b=smX5gmNata/n3NbPht+EprGvZK7OuyMig6y7xdBZjJmet4mrLOi6qHqP2sdNxI9A+
	 wZtunrDLTyyWdNZriqjphTMrtCAOmP8QWNjYzMdPfxBJbPreLg6ZWISJw+utP0t5WU
	 8XNMlqSsBMhdhfs4wIVy3RxqaDsrzYVIlZ3A7bNs=
Date: Tue, 19 Aug 2025 15:20:44 -0700
To: mm-commits@vger.kernel.org,nicolas.frattaroli@collabora.com,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + listh-add-missing-kernel-doc-for-basic-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20250819222044.C1E01C113CF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list.h: add missing kernel-doc for basic macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     listh-add-missing-kernel-doc-for-basic-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/listh-add-missing-kernel-doc-for-basic-macros.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: list.h: add missing kernel-doc for basic macros
Date: Tue, 19 Aug 2025 00:55:07 -0700

kernel-doc for the basic LIST_HEAD() and LIST_HEAD_INIT() macros has been
missing forever (i.e., since git).  Add them for completeness.

Link: https://lkml.kernel.org/r/20250819075507.113639-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/list.h~listh-add-missing-kernel-doc-for-basic-macros
+++ a/include/linux/list.h
@@ -20,8 +20,16 @@
  * using the generic single-entry routines.
  */
 
+/**
+ * LIST_HEAD_INIT - initialize a &struct list_head's links to point to itself
+ * @name: name of the list_head
+ */
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
+/**
+ * LIST_HEAD - definition of a &struct list_head with initialization values
+ * @name: name of the list_head
+ */
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

listh-add-missing-kernel-doc-for-basic-macros.patch

