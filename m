From: akpm@linux-foundation.org
Subject: + security-fix-typo-in-security_task_prctl.patch added to -mm
 tree
Date: Mon, 21 Sep 2015 13:55:10 -0700
Message-ID: <56006eae.c4MRX4TjtL7RD807%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbIUUzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 16:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, james.l.morris@oracle.com, luto@kernel.org, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/security.h: fix typo in security_task_prctl()
has been added to the -mm tree.  Its filename is
     security-fix-typo-in-security_task_prctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/security-fix-typo-in-security_task_prctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/security-fix-typo-in-security_task_prctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: include/linux/security.h: fix typo in security_task_prctl()

   prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_DAC_OVERRIDE, 0, 0)

failed with EINVAL because of a typo in kernel code.

Andy said: "on CONFIG_SECURITY=n systems (which is all that this affects),
this only matters for PR_CAP_AMBIENT, which is new".

Signed-off-by: Jann Horn <jann@thejh.net>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <james.l.morris@oracle.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff -puN include/linux/security.h~security-fix-typo-in-security_task_prctl include/linux/security.h
_

Patches currently in -mm which might be from jann@thejh.net are

security-fix-typo-in-security_task_prctl.patch

