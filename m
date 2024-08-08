Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8169450
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081325; cv=none; b=JDXYGeu1u40G5Qe6xt4X80VKezh9dlBV6oTZxvLoyquf9bihZ/72B073gwwUhtwSxcL6+tzSLsECAkU8csfWYIQzU+6mN6cbSOkD8lxr/udBRwRvr5TQ9igURdOobJi18oqjWo7Dj4u/iUJccPgWTM4qE9NaGEBgqjvsFQ+DGSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081325; c=relaxed/simple;
	bh=JTYTXhOKbf9IpEGsGHSHk0WpVq27+fJO9z8lJ6ygwIw=;
	h=Date:To:From:Subject:Message-Id; b=mcTWMo69MPZQh02DDnRO8Jfv9CYMWnAgeIjnNz/Fd2A0qUPX0rNzQP3OQuELmnAO06rZBfPJRITXgmdy7Aw2InxP657LFa1eSKsqnIlW+p7+MCqsardEzKrehkqlHoc/2MDEIn3Xn+Afi14UJmMwbdfFHXob4ar632dUx1EOKug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xoS1XZzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoS1XZzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D09C4AF10;
	Thu,  8 Aug 2024 01:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081325;
	bh=JTYTXhOKbf9IpEGsGHSHk0WpVq27+fJO9z8lJ6ygwIw=;
	h=Date:To:From:Subject:From;
	b=xoS1XZzJ8abMtmncTAoV934Egz180rBYAe0ZUxr0DxFU3YUEy55jJW0LsU4Fk2Tb1
	 ia/MBm7QzJn6p2PmYsmMIXzrCl8fGob0lOpaK23qlIqJNHqWAsq32fOUbE1fJChbfM
	 mtzq/Ds/5xpEgodPnFt8ypgh8gKErM5SQUG/V8Kc=
Date: Wed, 07 Aug 2024 18:42:04 -0700
To: mm-commits@vger.kernel.org,yangx.jy@fujitsu.com,xuyang2018.jy@fujitsu.com,liwang@redhat.com,jstancek@redhat.com,chrubis@suse.cz,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-ltp-members-and-web.patch removed from -mm tree
Message-Id: <20240808014204.E2D09C4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update LTP members and web
has been removed from the -mm tree.  Its filename was
     maintainers-update-ltp-members-and-web.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: Update LTP members and web
Date: Fri, 26 Jul 2024 09:20:09 +0200

LTP project uses now readthedocs.org instance instead of GitHub wiki.

LTP maintainers are listed in alphabetical order.

Link: https://lkml.kernel.org/r/20240726072009.1021599-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Li Wang <liwang@redhat.com>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Xiao Yang <yangx.jy@fujitsu.com>
Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-ltp-members-and-web
+++ a/MAINTAINERS
@@ -13324,14 +13324,16 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
+M:	Andrea Cervesato <andrea.cervesato@suse.com>
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
 M:	Li Wang <liwang@redhat.com>
 M:	Yang Xu <xuyang2018.jy@fujitsu.com>
+M:	Xiao Yang <yangx.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
-W:	http://linux-test-project.github.io/
+W:	https://linux-test-project.readthedocs.io/
 T:	git https://github.com/linux-test-project/ltp.git
 
 LTR390 AMBIENT/UV LIGHT SENSOR DRIVER
_

Patches currently in -mm which might be from pvorel@suse.cz are


