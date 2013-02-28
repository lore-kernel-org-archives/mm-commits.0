From: akpm@linux-foundation.org
Subject: [merged] scripts-kernel-doc-handle-struct-member-__aligned-without-numbers.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:37 -0800
Message-ID: <20130228201038.1BA2531C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:50433 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3B1UKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:40 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244616vea.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nm@ti.com, fengguang.wu@intel.com, johannes.berg@intel.com, mmarek@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kernel-doc: handle struct member __aligned without numbers
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-handle-struct-member-__aligned-without-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nishanth Menon <nm@ti.com>
Subject: scripts/kernel-doc: handle struct member __aligned without numbers

commit ef5da59f126 ("scripts/kernel-doc: handle struct member __aligned")
permits "char something [123] __aligned(8);".

However, by using \d we constraint ourselves with integers.  This is not
always the case.  In fact, it might be better to do char something[123]
__aligned(sizeof(u16));

For example, With wireless_dev defining:
u8 address[ETH_ALEN] __aligned(sizeof(u16));
With \d, scripts/kernel-doc erroneously says:
Warning(include/net/cfg80211.h:2618): Excess struct/union/enum/typedef member 'address' description in 'wireless_dev'
This is because the regex __aligned\s*\(\d+\) fails match at \d as
sizeof is used.

So replace \d with . to indicate "something" in kernel-doc
to ignore __aligned(SOMETHING) in structs. With this change,
we can use integers OR sizeof() or macros as we please.

Signed-off-by: Nishanth Menon <nm@ti.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-handle-struct-member-__aligned-without-numbers scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-handle-struct-member-__aligned-without-numbers
+++ a/scripts/kernel-doc
@@ -1750,7 +1750,7 @@ sub dump_struct($$) {
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
-	$members =~ s/__aligned\s*\(\d+\)//gos;
+	$members =~ s/__aligned\s*\(.+\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
_

Patches currently in -mm which might be from nm@ti.com are

origin.patch
linux-next.patch

