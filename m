Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CC6363
	for <mm-commits@vger.kernel.org>; Fri,  8 Mar 2024 00:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709856888; cv=none; b=WMSMDj7ozmCScmsElfx9RlPL3oj5i90WMvOqOcWzSuQErbL67lREu2HLQI6itXIA0x/tMbCbZu6ugEf77q3zbKjzOsWfnSqATGZFk9Hb0akQvnCul2XpIFwNXHRCu3O9tcOXxv+7sBMAcVTHLqATGutvxzuZIw9iXasF1bqeEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709856888; c=relaxed/simple;
	bh=1zaqLWWePTvhmriBcwdErvS6FrqVOOVU+a+JSr+H+gE=;
	h=Date:To:From:Subject:Message-Id; b=eQRjKGPck30WI3VJ5gR4zSeZ+ZF9ND1GJ5QubcQcoPsIU6KiPobDRUkDHc1ec//CC/P9sIdvTZ5Mqsft/rb9M9uV2761J/8JBNwce7p5L4WU3fsu9b7cJLGgAyfJ0viqR0HioEzvjqqrZ/hhjtBYz85/5iyfKF7FRA096zZ/Jug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFXSbL7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFXSbL7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F13C433F1;
	Fri,  8 Mar 2024 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709856888;
	bh=1zaqLWWePTvhmriBcwdErvS6FrqVOOVU+a+JSr+H+gE=;
	h=Date:To:From:Subject:From;
	b=IFXSbL7bxmEshBBTKqb8fNs8y9aHgSpXY7+4IhjQClZjFhasVkG5Snxzr0E6Sey/N
	 MjQQKxZI1dybkRzJ5o8N9EHZgNmf+58YQnOggERw3grvvSBDmpp88DrcteEH7LCPlO
	 7xQOi6aVjCAQpJZ0nNu6gUIL4E32ZvbFTQg3QSoI=
Date: Thu, 07 Mar 2024 16:14:47 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,p.raghav@samsung.com,mcgrof@kernel.org,Kuan-Ying.Lee@mediatek.com,koudai@google.com,kbingham@kernel.org,jan.kiszka@siemens.com,andrewjballance@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch removed from -mm tree
Message-Id: <20240308001448.24F13C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: fix invalid escape sequence warning
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Ballance <andrewjballance@gmail.com>
Subject: scripts/gdb/symbols: fix invalid escape sequence warning
Date: Sun, 3 Mar 2024 19:25:07 -0600

With python 3.12, '\.' results in this warning
    SyntaxWarning: invalid escape sequence '\.'

Link: https://lkml.kernel.org/r/20240304012507.240380-1-andrewjballance@gmail.com
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Koudai Iwahori <koudai@google.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-fix-invalid-escape-sequence-warning
+++ a/scripts/gdb/linux/symbols.py
@@ -82,7 +82,7 @@ lx-symbols command."""
         self.module_files_updated = True
 
     def _get_module_file(self, module_name):
-        module_pattern = ".*/{0}\.ko(?:.debug)?$".format(
+        module_pattern = r".*/{0}\.ko(?:.debug)?$".format(
             module_name.replace("_", r"[_\-]"))
         for name in self.module_files:
             if re.match(module_pattern, name) and os.path.exists(name):
_

Patches currently in -mm which might be from andrewjballance@gmail.com are


