Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793738934;
	b=lnjIIp31XuNCW2qjCNxub9/dbP3JRlgAapP57ggapphNbCRxgeHBIXwIAL+62iPSZwsn
	 iUXAXGrBrJpZbQaadCJyRe9QG13wVptT9gyV298yUM3PvU/2Zc5VwpXJp2mt8wEsKlLt1
	 YLiNic0biho2f0SXni9Qi9PYcP3aTwesOojH/VXdkptGUBGi7Nnu9Jria5mRJK4C1GqSh
	 vvTKtnYzKda6tpUrRrG5msyhVWMmzRpSx12J22tBG9qaNrVGNAG2GY7s8vqmrKIcze8dp
	 TajNVEA/ZE4S/KYS1cdosLwxHI/tk1r0+HCf4js0Z9lpUCnXnFJmOesFE6ZouGgFwtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793738934;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2peLafDDXm9eoIcIiWv+lusocr5WPrpMR/0FdoYe2Bg=;
	b=SR17Afa5cpPgMpv7C41YBXCQxLvGN/umjSp+2aeF3ExtGbUfy2PJSu4OQXtMJxvZNLtt
	 CumGdkgF33t39WarZixsf8zmBRmrOqOkCh1YhKlsxrGrAFmGmKntW92ELTsOa8w48EDI4
	 GN8doTswBEULJHhj0MBIzm5lmM7TfZ/ff+lELSnSqUYmvg+WmqBwWxBb2a0i5a2i97mx4
	 De1yyx95H62eSCtJvXneNoPNVxtGWCCJMrGiqVZXqK6gv9RXglLiw1PFR+al3+2HJx6IW
	 OBmaSNKEXNDKADAtqNigvVb3vSdQUf4WpMYnjSJr9IgUAq9x62ZeKk70jUSmhdrVLUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xN+HCiLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F921606A31B
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 20:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xN+HCiLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FFB1F000C1;
	Tue,  3 Nov 2026 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793738934;
	bh=2peLafDDXm9eoIcIiWv+lusocr5WPrpMR/0FdoYe2Bg=;
	h=Date:To:From:Subject;
	b=xN+HCiLpL0eE5ggcaYtmFGufibToul2OdJlOjj8gFf2EifZbu2lIBiHAx2YjamCQ+
	 zSgCQXCeJOvkEZ+us1QL805LnKeCiuj1m+8vSU2ni5HLv0P3jgrbits3gh/DfgfohH
	 pxYcPj8UfEnjhPzjXkWnPP704U/16X92PWKNBGps=
Date: Tue, 03 Nov 2026 12:48:53 -0800
To: mm-commits@vger.kernel.org,sashal@kernel.org,hamdy.aea@protonmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktrace-preserve-input-while-reading-lines.patch added to mm-nonmm-unstable branch
Message-Id: <20261103204853.F0FFB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: scripts: decode_stacktrace: preserve input while reading lines
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktrace-preserve-input-while-reading-lines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktrace-preserve-input-while-reading-lines.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hamdy Abou El Anein <hamdy.aea@protonmail.com>
Subject: scripts: decode_stacktrace: preserve input while reading lines
Date: Tue, 03 Nov 2026 17:42:03 +0100

Plain read strips leading and trailing whitespace and interprets
backslashes before the decoder sees a line.  It also drops a final line
without a newline.  This loses log text and defeats the alignment
preservation in handle_line().

Read with an empty IFS and -r, and process a nonempty final fragment.

Tested passthrough text with indentation, backslashes and trailing spaces,
plus a real debug-enabled object and stack entries terminated by LF, CRLF
or EOF.  All three stack entries decode with their original indentation.

AI assistance: ChatGPT/Codex identified the issue and prepared the
change, commit message and executable regression tests.

Link: https://lore.kernel.org/20261103164203.129660-1-info@daylightlinux.ch
Fixes: dbd1abb20971 ("decode_stacktrace: make stack dump output useful again")
Signed-off-by: Hamdy Abou El Anein <hamdy.aea@protonmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sasha Levin <sashal@kernel.org>
---

 scripts/decode_stacktrace.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-preserve-input-while-reading-lines
+++ a/scripts/decode_stacktrace.sh
@@ -346,7 +346,7 @@ handle_line() {
 	echo "${spaces[$last]}${symbol}${module:+ ${module}}${info_str:+ ${info_str}}"
 }
 
-while read line; do
+while IFS= read -r line || [[ -n $line ]]; do
 	# Strip unexpected carriage return at end of line
 	line=${line%$'\r'}
 
_

Patches currently in -mm which might be from hamdy.aea@protonmail.com are

scripts-decode_stacktrace-preserve-input-while-reading-lines.patch

