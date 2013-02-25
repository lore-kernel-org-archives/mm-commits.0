From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-handle-struct-member-__aligned-without-numbers.patch added to -mm tree
Date: Mon, 25 Feb 2013 15:09:03 -0800
Message-ID: <20130225230903.B053E31C27E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51996 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3BYXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 18:09:05 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so366621vch.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 15:09:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nm@ti.com, fengguang.wu@intel.com, johannes.berg@intel.com, mmarek@suse.cz, rdunlap@infradead.org


The patch titled
     Subject: scripts/kernel-doc: handle struct member __aligned without numbers
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-handle-struct-member-__aligned-without-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scripts-kernel-doc-handle-struct-member-__aligned-without-numbers.patch

