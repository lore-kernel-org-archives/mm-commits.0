Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C83264D5
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622259; cv=none; b=ENZty6DALU089utOHwHJo2X/OJ1SiWxqwddc1yjDe1vLsWPxfi3SQDUtFg78BDyxFR+WuG7EQopTL8por/wQDEB99s1WjrSTDaBprA60ZJ/uE57LNFKRdHQAcAl2J1UKyUh5Rpc94zGzOKot8Cn+BMrxYAeIfT+eq9ReV4V6yFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622259; c=relaxed/simple;
	bh=s8QTqVCkuF4hyoC2hFckOpWj0W/noDOMzMrEL62w+hg=;
	h=Date:To:From:Subject:Message-Id; b=X5DGYbvipFR9N46maFj0nF4EgS0e/xGfcu5uSPyHDMZzjPy04SBHudqFEA/Ae77E2U4obFLGXcYiiwYv6XDPpDYeSRQz2ZZ8g2QJx2kbYp0diI9iqWpq9v0O+RbewRryiqKH6r2iYiCEutzyTxRIKeEoq609ELWZ2igDqolRrkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CbKiJ74d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CbKiJ74d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A94F1F000E9;
	Tue, 25 Aug 2026 01:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622258;
	bh=bbRlCltqUjAM2ldA9MHxzc+ohr+1T0AVSJ8E/eXr0xE=;
	h=Date:To:From:Subject;
	b=CbKiJ74d8lxJ+bgm9ms+i0wMKdoHNwAF3JaVyQxBFjaXhlh3oYgevn4mqLjBg8UwT
	 XBfB7lGJ2gzMiy/kcvAoCixo7WYzHi8Zz4hqZ2CPoxxzTxFKgS2v9/vB7GobRyLFRY
	 Bu5N5vRRhfzLWket7JVZcZQzQqkAg2Loh56v1uuA=
Date: Mon, 24 Aug 2026 18:44:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch removed from -mm tree
Message-Id: <20260825014418.4A94F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
Date: Wed, 10 Jun 2026 15:09:04 -0700

<linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
determine whether to disable the mt_in_rcu() function (by making it always
return false).  This macro is not reachable via Kconfig, despite its name,
and is not documented anywhere.  Remove it to avoid polluting the CONFIG_*
namespace.

Discovered while searching for CONFIG_* symbols referenced in code but not
defined in any Kconfig file.

Link: https://lore.kernel.org/20260610220905.99860-1-enelsonmoore@gmail.com
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Liam Howlett <liam@infradead.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-undocumented-config_maple_rcu_disabled-macro
+++ a/include/linux/maple_tree.h
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
-/* #define CONFIG_MAPLE_RCU_DISABLED */
 
 /*
  * Allocated nodes are mutable until they have been inserted into the tree,
@@ -864,9 +863,6 @@ static inline void mt_init(struct maple_
 
 static inline bool mt_in_rcu(struct maple_tree *mt)
 {
-#ifdef CONFIG_MAPLE_RCU_DISABLED
-	return false;
-#endif
 	return mt->ma_flags & MT_FLAGS_USE_RCU;
 }
 
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are


