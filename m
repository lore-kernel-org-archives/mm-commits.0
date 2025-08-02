Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A9423D291
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161348; cv=none; b=TCWHMZWQJDFlqEbZJKbzHAPODYCxwowbLreXER9LIQ6B3LI+A8TNT//jfwOZ6o794tyqiZYxtzqvgMHD8pkH0+pnq+JAB31Xf0IWWSQItlmXqMZiftrNVu/1rWxZQ6k1xlk/4mNzU8F/qofsQscaUhPfAqANWzcA5ME+0AsYQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161348; c=relaxed/simple;
	bh=iEAH6FKG+xbfY6ebm8Ir9aoAMzaovnd0W/MQqHbSl0I=;
	h=Date:To:From:Subject:Message-Id; b=cgnJ77vv8mGTatYsICmWwBjnmUxd7byaUomy3hZQnMXIye2dKrnP7oavxuWwFWMgwIws53CtPHKGGqcolJkR7t9hm/VP3Cv9ONEN9b+TVHhdI4bdWeNdGUehVzF8elVDRPReEv179HKBR7s/nLlVyypJLCwF30Cntu8Z62EiQcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DMz8rn1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DMz8rn1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32D3C4CEEF;
	Sat,  2 Aug 2025 19:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161348;
	bh=iEAH6FKG+xbfY6ebm8Ir9aoAMzaovnd0W/MQqHbSl0I=;
	h=Date:To:From:Subject:From;
	b=DMz8rn1QEqGdKuIM7LKXxaIVwQ63letTFjlY+LuweUoCUq8fQM24HznonQ7TcpuIH
	 oaiMp6vVqga4atkgqZF+yeO31NH8tHnSaS4uYUZVdqNLWNESbJIVxRI5wKHdGh9LhE
	 NDFuIUS/ktr10KNBh+flQrlLTfEjusbfoOxDTytk=
Date: Sat, 02 Aug 2025 12:02:27 -0700
To: mm-commits@vger.kernel.org,jgross@suse.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xen-xenbus-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250802190227.F32D3C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xen/xenbus: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     xen-xenbus-fix-typo-notifer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: xen/xenbus: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:30 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/C6633C66376C709A+20250722073431.21983-7-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/xen/xenbus.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/xen/xenbus.h~xen-xenbus-fix-typo-notifer
+++ a/include/xen/xenbus.h
@@ -180,7 +180,7 @@ int xenbus_printf(struct xenbus_transact
  * sprintf-style type string, and pointer. Returns 0 or errno.*/
 int xenbus_gather(struct xenbus_transaction t, const char *dir, ...);
 
-/* notifer routines for when the xenstore comes up */
+/* notifier routines for when the xenstore comes up */
 extern int xenstored_ready;
 int register_xenstore_notifier(struct notifier_block *nb);
 void unregister_xenstore_notifier(struct notifier_block *nb);
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


