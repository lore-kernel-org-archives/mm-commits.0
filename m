From: akpm@osdl.org
Subject: + qconf-make-xconfig-search-dialog.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:58:16 -0800
Message-ID: <200701022158.l02LwHws031149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbXABV7A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shlomif@iglu.org.il, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     qconf: "make xconfig" Search Dialog
has been added to the -mm tree.  Its filename is
     qconf-make-xconfig-search-dialog.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: "make xconfig" Search Dialog
From: Shlomi Fish <shlomif@iglu.org.il>

This patch is a reworked version of:

http://www.ussg.iu.edu/hypermail/linux/kernel/0603.3/0990.html

It adds a search dialog to the kernel's "make xconfig" configuration
applet.

Changes in this release include:

1. Fixed formatting.

2. The items are now displayed in a tree instead of in a flat list. 
   (With all the necessary changes).

3. Updated to apply against the recent kernel version.

The To do is:

1. Implemented more sophisticated querying.

2. Fix the fact that the top categories in the QListView do not have a
   visible [+] sign next to them to expand them.  (Albeit they are expanded
   upon a double click).

3. Make sure double clicking an end-item opens and highlights it in the
   main application.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |  238 +++++++++++++++++++++++++++++++++++++
 scripts/kconfig/qconf.h  |   48 +++++++
 2 files changed, 286 insertions(+)

diff -puN scripts/kconfig/qconf.cc~qconf-make-xconfig-search-dialog scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-make-xconfig-search-dialog
+++ a/scripts/kconfig/qconf.cc
@@ -21,6 +21,10 @@
 #include <qfiledialog.h>
 #include <qdragobject.h>
 #include <qregexp.h>
+#include <qdialog.h>
+#include <qlayout.h>
+#include <qlabel.h>
+#include <qpushbutton.h>
 
 #include <stdlib.h>
 
@@ -1325,6 +1329,8 @@ ConfigMainWindow::ConfigMainWindow(void)
 	  connect(splitViewAction, SIGNAL(activated()), SLOT(showSplitView()));
 	QAction *fullViewAction = new QAction("Full View", QPixmap(xpm_tree_view), "Full View", 0, this);
 	  connect(fullViewAction, SIGNAL(activated()), SLOT(showFullView()));
+	QAction *findAction = new QAction("Find", QPixmap(xpm_save), "&Find", CTRL+Key_F, this);
+	  connect(findAction, SIGNAL(activated()), SLOT(findEntries()));
 
 	QAction *showNameAction = new QAction(NULL, "Show Name", 0, this);
 	  showNameAction->setToggleAction(TRUE);
@@ -1378,6 +1384,11 @@ ConfigMainWindow::ConfigMainWindow(void)
 	config->insertSeparator();
 	quitAction->addTo(config);
 
+	// create file menu
+	QPopupMenu* editMenu = new QPopupMenu(this);
+	menu->insertItem("&Edit", editMenu);
+	findAction->addTo(editMenu);
+
 	// create options menu
 	QPopupMenu* optionMenu = new QPopupMenu(this);
 	menu->insertItem("&Option", optionMenu);
@@ -1449,6 +1460,233 @@ void ConfigMainWindow::saveConfig(void)
 		QMessageBox::information(this, "qconf", "Unable to save configuration!");
 }
 
+
+FindDialog::FindDialog( QWidget* parent, const char* name, bool modal, WFlags fl )
+	: QDialog( parent, name, modal, fl )
+{
+	main_layout = new QVBoxLayout(this, 11, 6, "main_layout");
+	main_layout->addWidget(new QLabel("Query:", this, "label1"));
+	queryLineEdit = new QLineEdit(this, "queryLineEdit");
+	main_layout->addWidget(queryLineEdit);
+	findButton = new QPushButton("Find", this, "findButton");
+	main_layout->addWidget(findButton);
+	connect( findButton, SIGNAL( clicked() ), this, SLOT( performQuery() ) );
+	results = new QListView(this, "results");
+	results->addColumn("Item");
+	main_layout->addWidget(results);
+}
+
+FindDialog::~FindDialog()
+{
+}
+
+static QString * get_parent_disp(struct menu * menu)
+{
+	QString s;
+	if (menu->sym)
+	{
+		if (menu->prompt)
+		{
+			s += menu->prompt->text;
+			if (menu->sym->name)
+			{
+				s += " (";
+				s += menu->sym->name;
+				s += ")";
+			}
+		}
+		else if (menu->sym->name)
+		{
+			s += menu->sym->name;
+		}
+	}
+	else if (menu->prompt)
+	{
+		s += menu->prompt->text;
+	}
+	return new QString(s);
+}
+
+QString * get_parent_string(struct menu * menu, int depth)
+{
+	QString * parent_disp = get_parent_disp(menu);
+	QString s;
+
+	/*
+	 * Append 'depth' tabs.
+	 * */
+	for(int i=0;i<depth;i++)
+	{
+		s += "\t";
+	}
+	s += *parent_disp;
+	s += "\n";
+
+	delete parent_disp;
+
+	return new QString(s);
+}
+
+static QString * get_item_display(MenuList * parents, struct menu * mymenu)
+{
+	MenuList::iterator it;
+	QString * item;
+#if 0
+	int depth;
+#else
+	int depth=0;
+#endif
+
+	item = new QString();
+
+#if 0
+	for (depth=0, it = parents->begin(); it != parents->end() ; ++it, ++depth)
+	{
+		QString * parent_string = get_parent_string(*it, depth);
+		*item += *parent_string;
+		delete parent_string;
+	}
+#endif
+
+	QString * string = get_parent_string(mymenu, depth);
+	*item += *string;
+	delete string;
+
+	return item;
+}
+
+QListViewItem * ListViewBranch::newItem(QString & s)
+{
+	if (which == ISNULL)
+	{
+		// Shouldn't happen.
+		throw "Hello";
+	}
+	else if (which == ITEM)
+	{
+		return new QListViewItem(item, s);
+	}
+	else
+	{
+		return new QListViewItem(view, s);
+	}
+
+}
+
+ListViewBranch ListViewBranch::insertItem(QString & s)
+{
+	return ListViewBranch(newItem(s));
+}
+
+bool FindDialog::matches(struct menu * mymenu, QString & query)
+{
+	struct symbol * sym = mymenu->sym;
+
+	if (!sym)
+	{
+		return false;
+	}
+
+	QString help(sym->help);
+	QString name(sym->name);
+
+	return (help.contains(query, FALSE) || name.contains(query, FALSE));
+}
+
+void FindDialog::handle_match(MenuList * parents, ListViewMenuList * * last_branch)
+{
+	// TODO : Name to something more meaningful than
+	// it2
+	MenuList::iterator it;
+	ListViewMenuList::iterator it2;
+
+	// Find the last branch that was allocated
+	it = parents->begin();
+	it2 = (*last_branch)->begin();
+
+	for (;(*it2).menu == *it ; ++it, ++it2)
+	{
+	}
+
+	ListViewMenuList * new_branch = new ListViewMenuList;
+	MenuList new_menu;
+
+	ListViewMenuList::iterator copy_branches;
+	MenuList::iterator copy_menu;
+	for (copy_branches = (*last_branch)->begin(),copy_menu = parents->begin();
+		copy_branches != it2;
+		++copy_branches, ++copy_menu)
+	{
+		new_branch->append(*copy_branches);
+		new_menu.append(*copy_menu);
+	}
+
+	for (; it != parents->end(); ++it)
+	{
+		ListViewMenuItem new_item;
+		new_item.menu = *it;
+
+		QString * str = get_item_display(&new_menu, *it);
+		new_item.branch = new_branch->back().branch.insertItem(*str);
+
+		new_branch->append(new_item);
+		new_menu.append(*it);
+		delete str;
+	}
+
+	// Update to the the new branch
+	delete *last_branch;
+	*last_branch = new_branch;
+}
+
+void FindDialog::search(QString & query, MenuList * parents, ListViewMenuList * * last_branch)
+{
+	struct menu * child;
+
+	struct menu * mymenu = parents->back();
+
+	if (matches(mymenu, query))
+	{
+		handle_match(parents, last_branch);
+	}
+
+	for (child = mymenu->list; child ; child = child->next)
+	{
+		MenuList new_parents(*parents);
+		new_parents.append(child);
+		search(query, &new_parents, last_branch);
+	}
+}
+
+void FindDialog::performQuery(void)
+{
+	QString query = queryLineEdit->text();
+	results->clear();
+
+	MenuList parents;
+	ListViewMenuList * mybranch = new ListViewMenuList;
+
+	{
+		ListViewMenuItem i;
+		i.branch = ListViewBranch(results);
+		i.menu = &rootmenu;
+		mybranch->append(i);
+	}
+
+	parents.append(&rootmenu);
+
+	search(query, &parents, &mybranch);
+
+	delete mybranch;
+	// printf("Query for \"%s\"\n", (const char *)queryLineEdit->text());
+}
+
+void ConfigMainWindow::findEntries(void)
+{
+	FindDialog * dlg = new FindDialog(this, "dialog", TRUE);
+	dlg->exec();
+}
+
 void ConfigMainWindow::saveConfigAs(void)
 {
 	QString s = QFileDialog::getSaveFileName(".config", NULL, this);
diff -puN scripts/kconfig/qconf.h~qconf-make-xconfig-search-dialog scripts/kconfig/qconf.h
--- a/scripts/kconfig/qconf.h~qconf-make-xconfig-search-dialog
+++ a/scripts/kconfig/qconf.h
@@ -4,6 +4,7 @@
  */
 
 #include <qlistview.h>
+#include <qlistbox.h>
 #if QT_VERSION >= 300
 #include <qsettings.h>
 #else
@@ -304,6 +305,7 @@ public:
 	ConfigMainWindow(void);
 public slots:
 	void changeMenu(struct menu *);
+	void findEntries(void);
 	void setMenuLink(struct menu *);
 	void listFocusChanged(void);
 	void goBack(void);
@@ -332,3 +334,49 @@ protected:
 	QSplitter* split1;
 	QSplitter* split2;
 };
+
+typedef QValueList<struct menu *> MenuList;
+
+struct ListViewBranch
+{
+	enum { ISNULL, ITEM, VIEW } which;
+	union
+	{
+		QListViewItem * item;
+		QListView * view;
+	};
+	ListViewBranch() { which = ISNULL; item = NULL; }
+	ListViewBranch(QListView * v) { view = v; which = VIEW; }
+	ListViewBranch(QListViewItem * i) { item = i; which = ITEM; }
+	QListViewItem * newItem(QString & s);
+	ListViewBranch insertItem(QString & s);
+};
+
+struct ListViewMenuItem
+{
+	ListViewBranch branch;
+	struct menu * menu;
+};
+
+typedef QValueList<struct ListViewMenuItem> ListViewMenuList;
+
+class FindDialog : public QDialog
+{
+	Q_OBJECT
+	public:
+	FindDialog( QWidget* parent = 0, const char* name = 0, bool modal = FALSE, WFlags fl = 0 );
+	~FindDialog();
+	QVBoxLayout * main_layout;
+	QLineEdit * queryLineEdit;
+	QPushButton * findButton;
+	QListView * results;
+public slots:
+	void performQuery();
+public:
+	bool matches(struct menu * mymenu, QString & query);
+	void search(QString & query, MenuList * parents,
+			ListViewMenuList * * last_branch);
+	void handle_match(MenuList * parents,
+			ListViewMenuList * * last_branch);
+};
+
_

Patches currently in -mm which might be from shlomif@iglu.org.il are

qconf-make-xconfig-search-dialog.patch
