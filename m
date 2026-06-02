Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B1E3BCD36
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439094; cv=none; b=D+9exi/SlH+2vKkSL2g5wQ9tg6f3e7YnlahGunDIy+DR7Nn/W7xsxG6OpIvYCBbh+r2AtVe6M9GsWrnSUvU61CCItdH7+tkb4MxsFu3s23qATV98LFW/cIFHSVAnx+9Use1outqtgpP0zX8uA8lQJQMXo5emqcr7bLOG9OBpSJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439094; c=relaxed/simple;
	bh=YmLn/79xaJFKFiQjtVlBHljGHfyvtSFH2XIUm/OmpmE=;
	h=Date:To:From:Subject:Message-Id; b=EtDNM9Hast4G2iQQDBAOnfNjDHnied6hgBWLWrVmhiubBuNmDmGzGmJsJywDy2yXq7RMZZT8b4uh4WCXW9+rw7Ees62BSgIqxO5mcbIMfPsf4+K5ld87MWURpmW1QSWEFJlRCERPbZluBN3Jzk/qhpJWssbD0CK9WifRw+CD51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V0vPY73F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V0vPY73F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C40D1F00898;
	Tue,  2 Jun 2026 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439093;
	bh=rxwjgP6P0LPUN+PHUnlB0icPBCeclZZJ8bQbhjhQY2g=;
	h=Date:To:From:Subject;
	b=V0vPY73FHgUYaFtMkUuyLXVVqNAxUXigWXvx8Ri6cFUU5OQIpI1Penfx/aHsKh82T
	 XU7mhBzA3tg59lNc/EHMtN4FqhxjoVgWJ8Eh4khh6gljtz/uyOaGUJ4MmgoNXcOTR8
	 G8YITSpYs84HL/GdpZ01B87nAk3U9Inz6CwtFKhk=
Date: Tue, 02 Jun 2026 15:24:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-data-attributes-monitoring.patch removed from -mm tree
Message-Id: <20260602222453.0C40D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support data attributes monitoring
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-data-attributes-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support data attributes monitoring
Date: Mon, 18 May 2026 16:40:56 -0700

Implement and register damon_operations->apply_probes() callback to
support data attributes monitoring.

Link: https://lore.kernel.org/20260518234119.97569-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   62 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-data-attributes-monitoring
+++ a/mm/damon/paddr.c
@@ -120,6 +120,67 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
+static bool damon_pa_filter_match(struct damon_filter *filter,
+		struct folio *folio)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
+		struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool pass = true;
+
+	damon_for_each_filter(f, p) {
+		if (damon_pa_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
+	return pass;
+}
+
+static void damon_pa_apply_probes(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			int i = 0;
+			phys_addr_t pa;
+			struct folio *folio;
+
+			pa = damon_pa_phys_addr(r->sampling_addr,
+					ctx->addr_unit);
+			folio = damon_get_folio(PHYS_PFN(pa));
+			damon_for_each_probe(p, ctx) {
+				if (damon_pa_filter_pass(pa, folio, p))
+					r->probe_hits[i]++;
+				i++;
+			}
+			if (folio)
+				folio_put(folio);
+		}
+	}
+}
+
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
@@ -371,6 +432,7 @@ static int __init damon_pa_initcall(void
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

