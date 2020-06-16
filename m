From: akpm@linux-foundation.org
Subject: + mm-memcg-prevent-missed-memorylow-load-tears.patch added
 to -mm tree
Date: Tue, 16 Jun 2020 13:20:00 -0700
Message-ID: <20200616202000.qyM9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730725AbgFPUUB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 16:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mkoutny@suse.com, mhocko@suse.com, chris@chrisdown.name


The patch titled
     Subject: mm/memcontrol.c: prevent missed memory.low load tears
has been added to the -mm tree.  Its filename is
     mm-memcg-prevent-missed-memorylow-load-tears.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prevent-missed-memory=
low-load-tears.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prevent-missed-memory=
low-load-tears.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm/memcontrol.c: prevent missed memory.low load tears

Looks like one of these got missed when massaging in f86b810c2610 ("mm,
memcg: prevent memory.low load/store tearing") with other linux-mm
changes.

Link: http://lkml.kernel.org/r/20200612174437.GA391453@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reported-by: Michal Koutn=FD <mkoutny@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-missed-memorylow-load-tears
+++ a/mm/memcontrol.c
@@ -6423,7 +6423,7 @@ enum mem_cgroup_protection mem_cgroup_pr
=20
 	if (parent =3D=3D root) {
 		memcg->memory.emin =3D READ_ONCE(memcg->memory.min);
-		memcg->memory.elow =3D memcg->memory.low;
+		memcg->memory.elow =3D READ_ONCE(memcg->memory.low);
 		goto out;
 	}
=20
@@ -6435,7 +6435,8 @@ enum mem_cgroup_protection mem_cgroup_pr
 			atomic_long_read(&parent->memory.children_min_usage)));
=20
 	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
-			memcg->memory.low, READ_ONCE(parent->memory.elow),
+			READ_ONCE(memcg->memory.low),
+			READ_ONCE(parent->memory.elow),
 			atomic_long_read(&parent->memory.children_low_usage)));
=20
 out:
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-prevent-missed-memorylow-load-tears.patch
