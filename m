Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E07779DF
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599274; cv=none; b=TeJdY/IIJZlrueMNO0K0X5WR+NsHZZEr8oCKPv5v/vAZliqUWRBGgn8GsxrzpGKe5eqqQdSQbWtMF1Z2osZjZ41ColOC2PLE6QYKWrYf9U6lcp2blrlEphV6OyVCGGE8pVhNEj/KwHgVks0wDn5Q9NidSP9vKxsuG3V1SCNdOaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599274; c=relaxed/simple;
	bh=dTNk4WPABAgRlU5Ve3FgWXejBG7PSi07/VXzn6xpb8Y=;
	h=Date:To:From:Subject:Message-Id; b=HTWT5Uo8KxbqVNBA30nyYhv1rBxS+yOtBanjw4AdtttqPN0QCzN9IK+x6wfWwHtsh788qY1Jff7AQ7LnQtkqnQMGkkcPkTCPRfXEqFyua4XU9BI1lFlbU0FemvrpS5dxf+FqDbaFLWrFw3Cia/wFElr6DV0xHuwADUU09xMckdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zCaZt9tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zCaZt9tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3B9C433F1;
	Tue,  5 Mar 2024 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599273;
	bh=dTNk4WPABAgRlU5Ve3FgWXejBG7PSi07/VXzn6xpb8Y=;
	h=Date:To:From:Subject:From;
	b=zCaZt9tjIeSzXJnOVQAbE9fv3HkFZlnHIS5E9BgPeqAGkXhV6zyNSB1hhmlI/bDtm
	 /obrCgtNXob2uCYI/3D+Q0chxxk0xOWOrntYtByCrtwS44sqHxc6bhx1ofuNhzG0RL
	 D1o6dRtLUoqLfOwQdRBcWg1whu3SCR5ff13cuxQQ=
Date: Mon, 04 Mar 2024 16:41:13 -0800
To: mm-commits@vger.kernel.org,kishon@ti.com,kishon@kernel.org,cassel@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-fix-kishons-email.patch removed from -mm tree
Message-Id: <20240305004113.CD3B9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: fix Kishon's email
has been removed from the -mm tree.  Its filename was
     mailmap-fix-kishons-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Niklas Cassel <cassel@kernel.org>
Subject: mailmap: fix Kishon's email
Date: Thu, 29 Feb 2024 14:43:18 +0100

Kishon updated his email in commit e6aa4edd2f5b ("MAINTAINERS: Update
Kishon's email address in PCI endpoint subsystem").

However, as he is no longer at TI, his TI email now bounces.

Add the same email as he has in MAINTAINERS to a mailmap, so that
get_maintainer.pl will not output an email that bounces.

(This is neeed as get_maintainer.pl will use "git author" to CC
people who have significantly modified the same file as you.)

Link: https://lkml.kernel.org/r/20240229134318.1201935-1-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-fix-kishons-email
+++ a/.mailmap
@@ -325,6 +325,7 @@ Kenneth W Chen <kenneth.w.chen@intel.com
 Kenneth Westfield <quic_kwestfie@quicinc.com> <kwestfie@codeaurora.org>
 Kiran Gunda <quic_kgunda@quicinc.com> <kgunda@codeaurora.org>
 Kirill Tkhai <tkhai@ya.ru> <ktkhai@virtuozzo.com>
+Kishon Vijay Abraham I <kishon@kernel.org> <kishon@ti.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

Patches currently in -mm which might be from cassel@kernel.org are


